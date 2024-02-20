# frozen_string_literal: true

class Failure
  def initialize(input_file:, output_file:, diff_file:)
    @input_file = input_file
    @output_file = output_file
    @diff_file = diff_file
  end
end