# frozen_string_literal: true

class RunAll < ActiveInteraction::Base
  object :options, class: Options
  string :executable

  def execute
    tmp_dir = options.tmp_dir

    if Dir.exist?(tmp_dir)
      system("rm -rf #{tmp_dir}/*")
    else
      Dir.mkdir(tmp_dir)
    end

    results = AssociateInputOutput.run!(options:).map do |input_file, expected_output_file|
      puts "Processing #{input_file}..."

      secret = SecureRandom.hex
      filename = "#{File.basename(input_file)}.#{secret}"
      out_file = "#{tmp_dir}/#{filename}.out"
      diff_file = "#{tmp_dir}/#{filename}.diff"
      run_command = "#{executable} < #{input_file} > #{out_file}"
      system(run_command)
      if options.verbose? || options.inputs_path.count == 1 # || $?.exitstatus != 0
        puts "#{'-' * 25} output #{'-' * 25}\n"
        system("cat #{out_file}")
        puts "\n" + '-' * 50
      end

      system("diff #{expected_output_file} #{out_file} > #{diff_file}")

      if $?.exitstatus != 0
        puts "Test failed. See #{diff_file} for details."
        next false
      end

      true
    end

    if results.all?
      puts "All tests passed."
    else
      puts "#{results.filter { |j| !j }.length} tests failed."
    end
  end
end
