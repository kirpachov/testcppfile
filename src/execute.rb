# frozen_string_literal: true

class Execute < ActiveInteraction::Base
  string :executable_path
  string :input_path
  string :output_path

  def execute
    system("cat #{input_path} | #{executable_path} > tmp/#{tmp_filename}.out")
    system("diff #{output_path} tmp/#{tmp_filename}.out > tmp/#{tmp_filename}.diff")

    return "tmp/#{tmp_filename}.diff" if File.size("tmp/#{tmp_filename}.diff") > 0

    File.delete("tmp/#{tmp_filename}.diff")
    nil
  end

  def tmp_filename
    @tmp_filename ||= "#{File.basename(input_path).split('.')[0..-2].join('.')}.#{SecureRandom.hex}"
  end
end
