# frozen_string_literal: true

# Get the options from the command line and parse them.
class Options < ActiveInteraction::Base
  array :argv do
    string
  end

  hash :settings do
    string :wd, default: PWD
  end

  def execute
    to_h
  end

  def to_h
    argv_hash.merge(
      cpp_file:,
      inputs_path:,
      outputs_path:,
      wd:,
    )
  end

  def files_to_watch
    [
      "#{cpp_file_dir}/**/*.cpp",
      "#{cpp_file_dir}/**/*.hpp",
      *inputs_path,
      *outputs_path,
    ]
  end

  def cpp_file_dir
    return nil if cpp_file.nil?

    File.dirname(cpp_file)
  end

  def watch?
    argv_hash[:watch] == true
  end

  def watch
    watch?
  end

  def wd
    (settings || {})[:wd] || PWD
  end

  def cpp_file
    return "#{wd}/#{argv[0]}" if File.file?("#{wd}/#{argv[0]}")

    argv[0]
  end

  def verbose?
    argv_hash[:verbose] == true
  end

  def inputs_path
    return [] if argv[1].nil?
    # return [argv[1]] if File.file?(argv[1])
    return ["#{wd}/#{argv[1]}"] if File.file?("#{wd}/#{argv[1]}")

    Dir.glob("#{wd}/#{argv[1]}/*")
  end

  def outputs_path
    return [] if argv[2].nil?
    # return [argv[2]] if File.file?(argv[2])
    return ["#{wd}/#{argv[2]}"] if File.file?("#{wd}/#{argv[2]}")

    Dir.glob("#{wd}/#{argv[2]}/*")
  end

  def argv_hash
    return @argv_hash if defined?(@argv_hash)

    @argv_hash = {}
    OptionParser.new do |parser|
      parser.banner = <<~BANNER
        Usage: testcppfile <cpp_file.cpp> <inputs_path> <outputs_path>"
          <cpp_file.cpp> - the file to be tested
          <inputs_path> - the path to the inputs. May be a file or a directory
          <outputs_path> - the path to the outputs. May be a file or a directory

      BANNER

      parser.on("-v", "--verbose", "Set VERBOSE status to true") do
        @argv_hash[:verbose] = true
      end

      parser.on("-b", "--build-options BUILD_OPTIONS", "Set the build options") do |lib|
        @argv_hash[:build_options] = lib
      end

      parser.on("-e", "--executable EXECUTABLE", "Set build output file") do |lib|
        @argv_hash[:executable] = lib
      end

      parser.on("-w", "--watch", "Watch for changes in the files") do
        @argv_hash[:watch] = true
      end

      parser.on("-h", "--help", "Prints this help") do
        puts parser
        exit
      end
    end.parse!(argv)

    @argv_hash
  end
end