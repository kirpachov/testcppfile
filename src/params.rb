# frozen_string_literal: true

# cli params
class Params < ActiveInteraction::Base
  array :argv do
    string
  end

  hash :configs do
    # Working directory
    string :wd
  end

  validate :argv_hash_not_help # KEEP ALWAYS AS FIRST VALIDATION
  validate :inputs_outputs_matching

  def execute
    argv_hash.merge(
      base_dir:,
      cpp_file:,
      inputs_outputs:,
      output_file:,
      verbose:,
      watch:,
    )
  end

  def argv_hash
    return @argv_hash if defined?(@argv_hash)

    @argv_hash = {}
    OptionParser.new do |parser|
      parser.on("-v", "--verbose", "Set VERBOSE status to true") do |lib|
        @argv_hash[:verbose] = true
      end

      parser.on("-h", "--help", "Prints this help") do
        puts parser
        exit
      end

      parser.on("-c OPTIONS", "--compile-options OPTIONS", "g++ compile options") do |lib|
        @argv_hash[:compile_options] = lib
      end

      parser.on("-o FILE", "--output-file FILE", "Output file name") do |lib|
        @argv_hash[:output_file] = lib
      end

      parser.on("-w", "--watch", "Watch for file changes") do |lib|
        @argv_hash[:watch] = true
      end
    end.parse!(argv)

    @argv_hash
  end

  def compile_options
    @compile_options ||= argv_hash[:compile_options]
  end

  def output_file
    @output_file ||= argv_hash[:output_file]
  end

  def verbose?
    argv_hash[:verbose] == true
  end

  def watch?
    argv_hash[:watch] == true
  end

  def watch
    watch?
  end

  def verbose
    verbose?
  end

  def base_dir
    return @base_dir if defined?(@base_dir)

    @base_dir = argv[0].to_s
    @base_dir = "#{wd}/#{base_dir}" if base_dir[0] != '/'
    @base_dir = @base_dir.gsub(/\/{2,}/, '/')

    if @base_dir.match?(/.cpp$/) && File.file?(@base_dir)
      @cpp_file = @base_dir
      @base_dir = @base_dir.split('/')[0...-1].join('/')
    end

    @base_dir = "#{@base_dir}/" if @base_dir[-1] != "/"

    @base_dir
  end

  def cpp_file
    return @cpp_file if defined?(@cpp_file)

    if base_dir.match?(/.cpp$/)
      @cpp_file = base_dir.split('/')[base_dir.split('/').length - 1]
    else
      all_cpp_files = Dir.glob("#{base_dir}*.cpp")
      if all_cpp_files.length == 1
        @cpp_file = all_cpp_files.first
      elsif all_cpp_files.length == 0
        errors.add :base, "No cpp files found in directory #{base_dir}"
      else
        errors.add :base, "Too many cpp files in dir. Select one between \n#{all_cpp_files.join("\n")}"
      end
    end

    @cpp_file
  end

  # Find matching input-output files.
  # Returns array of absolute paths to input-output files.
  # First file is input, second file is output.
  #
  # @return [Array<Array<String>>]
  # E.g: [["inputs/input0", "outputs/output0"], ["inputs/input1", "outputs/output1"], ...
  #
  # Case 1: separate input and output directories
  # inputs/input0, inputs/input1, ...
  # outputs/output0, outputs/output1, ...
  #
  # Case 2: single directory
  # test/input0, test/output0
  def inputs_outputs
    return @inputs_outputs if defined?(@inputs_outputs)

    if File.directory?("#{base_dir}/inputs") && File.directory?("#{base_dir}/outputs")
      outputs = Dir.glob("#{base_dir}/outputs/*").sort

      return @inputs_outputs = Dir.glob("#{base_dir}/inputs/*").sort!.map do |input|
        matching = outputs.filter { |output| output.match?(/#{File.basename(input.gsub('input', ''))}/) }.first

        matching = outputs.first if matching.nil?

        outputs = outputs.filter { |output| output != matching }

        [input, matching]
      end
    end
    @inputs_outputs = Dir.glob("#{base_dir}/**/**").filter { |file| file.match?(/input/) }.map do |input|
      output = input.gsub('input', 'output')
      [input, output]
    end
  end

  def wd
    return @wd if defined?(@wd)

    @wd = configs[:wd]
    # @wd = "#{Dir.getwd}/#{wd}" if wd[0] != '/'
    @wd
  end

  def format_path(path)
    path.to_s.gsub(/\/{2,}/, '/')
  end

  private

  def argv_hash_not_help
    argv_hash
  end

  def inputs_outputs_matching
    if inputs_outputs.length == 0
      return errors.add :base, "No input-output files found in directory #{base_dir}"
    end

    inputs_outputs.each do |input_output|
      input = input_output[0]
      output = input_output[1]

      if !File.file?(input)
        errors.add :base, "Input file not found: #{input}"
      end

      if !File.file?(output)
        errors.add :base, "Output file not found: #{output}"
      end

      if output.nil?
        errors.add :base, "No matching output file found for input file: #{input}"
      end
    end
  end
end
