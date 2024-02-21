#!/usr/bin/env ruby
# frozen_string_literal: true

PWD = Dir.pwd.dup.freeze
Dir.chdir __dir__

DEVELOPMENT = ENV['DEVELOPMENT'] == 'true'

require 'byebug' if DEVELOPMENT
require 'active_interaction'
require 'optionparser'
require 'filewatcher'

require_relative 'src/options'
Dir.glob('src/*.rb').each do|file|
  require_relative file
end

options = Options.run(argv: ARGV, settings: { wd: PWD })

puts options.to_h if options.verbose? || DEVELOPMENT

ValidateOptions.run!(options:)

executable = Build.run!(options:)

RunAll.run!(options:, executable:)

if options.watch?
  puts "Watching..."

  Filewatcher.new(options.files_to_watch).watch do |_changes|
    executable = Build.run!(options:)
    RunAll.run!(options:, executable:)
  end
end