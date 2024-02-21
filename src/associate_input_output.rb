# frozen_string_literal: true

# Will find associations between input and output files.
# Returns [Array<Array<String>>] where each element is an array with two strings: the input and the output file.
class AssociateInputOutput < ActiveInteraction::Base
  object :options, class: Options

  def execute
    inputs = options.inputs_path.sort
    outputs = options.outputs_path.sort

    inputs.map do |input|
      # output = outputs.find { |output| input_basename(input) == output_basename(output) }
      output = outputs.first
      outputs -= [output]

      [input, output]
    end
  end
end