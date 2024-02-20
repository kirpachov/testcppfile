# frozen_string_literal: true

class ExecuteAll < ActiveInteraction::Base
  object :params, class: Params

  def execute
    system('rm -rf tmp/*') if Dir.exist?('tmp')
    Dir.mkdir('tmp') unless Dir.exist?('tmp')

    puts "-" * 60 + Time.now.strftime("%k:%M:%S") + "-" * 60

    puts failed_executions.empty? ? 'ok' : 'failed'
  end

  def executable_path
    @executable_path ||= Compile.run!(params:)
  end

  def failed_executions
    @failed_executions ||= executions.filter do |execution|
      execution[:diff_path].present? && File.read(execution[:diff_path]).present?
    end
  end

  def executions
    @executions ||= params.inputs_outputs.map do |input_path, output_path|
      if params.verbose?
        puts "Running #{executable_path.to_s.format_path(params.wd)} with input #{input_path.to_s.format_path(params.wd)} and output #{output_path.to_s.format_path(params.wd)}"
      end

      diff_path = Execute.run!(executable_path:, input_path:, output_path:)
      puts "Diff: #{diff_path}" if diff_path.present?

      {
        diff_path: diff_path,
        input_path: input_path,
        output_path: output_path,
      }
    end
  end
end