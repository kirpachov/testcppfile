# frozen_string_literal: true

class PrintParams < ActiveInteraction::Base
  object :params, class: Params

  def execute
    puts " ** PARAMS ** "
    to_h.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  def to_h
    params.result.merge(
      base_dir: params.base_dir.to_s.format_path(params.wd),
      cpp_file: params.cpp_file.to_s.format_path(params.wd),
      inputs_outputs: params.inputs_outputs.map{ |arr| [arr[0].to_s.format_path(params.wd), arr[1].to_s.format_path(params.wd)] },
      output_file: params.output_file.to_s.format_path(params.wd)
    )
  end
end