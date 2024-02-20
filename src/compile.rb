# frozen_string_literal: true

# Will compile the cpp file
class Compile < ActiveInteraction::Base
  object :params, class: Params

  DEFAULT_COMPILE_OPTIONS = '-std=c++17'

  def execute
    if params.verbose?
      puts "Compiling..."
      puts "#{command}"
    end

    system(command)
    output_file
  end

  def command
    @command ||= "g++ #{params.cpp_file} #{compile_options} -o #{output_file}"
  end

  def output_file
    return params.output_file if params.output_file

    params.cpp_file.gsub(/.cpp$/, '')
  end

  def compile_options
    return params.compile_options if params.compile_options

    DEFAULT_COMPILE_OPTIONS
  end
end