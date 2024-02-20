#!/usr/bin/env ruby
# frozen_string_literal: true

PWD = Dir.pwd.dup.freeze
Dir.chdir __dir__

require 'byebug'
require 'active_interaction'
require 'optionparser'
require 'filewatcher'

require_relative 'src/params'
Dir.glob('src/*.rb').each { |file| require_relative file }

params = Params.run(argv: ARGV, configs: { wd: PWD })

raise params.errors.full_messages.join("\n") if params.invalid?

PrintParams.run!(params: params, wd: PWD) if params.verbose?

ExecuteAll.run!(params:)

if params.watch?
  puts "Watching..."

  Filewatcher.new([
                    "#{params.base_dir}/**/*.cpp",
                    "#{params.base_dir}/**/*.hpp",
                    params.cpp_file,
                    *params.inputs_outputs.flatten.uniq,
                  ]).watch do |_changes|
    ExecuteAll.run!(params:)
  end
end