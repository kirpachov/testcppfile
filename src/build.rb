# frozen_string_literal: true

# Will build the cpp file and return the path to the executable
class Build < ActiveInteraction::Base
  DEFAULT_BUILD_OPTIONS = '-std=c++11'.freeze
  object :options, class: Options

  validate :options_cpp_file_is_present
  validate :options_cpp_file_exists

  def execute
    puts command if options.verbose?
    system command

    return nil if $?.exitstatus != 0

    executable
  end

  def command
    @command ||= "g++ #{options.cpp_file} -o #{executable} #{build_options}"
  end

  def executable
    @executable ||= options.to_h[:executable] || options.cpp_file.gsub(/\.cpp$/, '')
  end

  def build_options
    @build_options ||= options.to_h[:build_options] || DEFAULT_BUILD_OPTIONS
  end

  private

  def options_cpp_file_is_present
    return if options.cpp_file

    errors.add(:options, 'cpp file is not present')
  end

  def options_cpp_file_exists
    return if File.exist?(options.cpp_file.to_s)

    errors.add(:options, "cpp file #{options.cpp_file} does not exist")
  end
end
