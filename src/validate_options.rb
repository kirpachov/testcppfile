# frozen_string_literal: true

# Check if application can run with provided options.
class ValidateOptions < ActiveInteraction::Base
  object :options, class: Options

  def execute
    validate_cpp_file
    validate_inputs
    validate_outputs
    validate_inputs_outputs_match
    validate_inputs_presence
    validate_outputs_presence
    validate_tmp_dir

    if errors.any?
      puts errors.full_messages.join("\n")
      exit
    end
  end

  def validate_tmp_dir
    tmp_dir = options.tmp_dir
    return errors.add(:tmp_dir, "should be a directory. Got a file.") if File.file?(tmp_dir)

    FileUtils.mkdir_p(tmp_dir) unless Dir.exist?(tmp_dir)
    return if Dir.glob("#{tmp_dir}/*").empty?

    errors.add(:tmp_dir, "should be empty. Got #{Dir.glob("#{tmp_dir}/*").join(', ')}")
  end

  def validate_inputs_presence
    return if options.to_h[:inputs_path].any?

    errors.add(:base, "inputs cannot be empty")
  end

  def validate_outputs_presence
    return if options.to_h[:outputs_path].any?

    errors.add(:base, "outputs cannot be empty")
  end

  def validate_inputs_outputs_match
    return if options.to_h[:inputs_path].length == options.to_h[:outputs_path].length

    errors.add(:base, "inputs and outputs do not match. Got #{options.to_h[:inputs_path].length} inputs and #{options.to_h[:outputs_path].length} outputs")
  end

  def validate_cpp_file
    unless options.to_h[:cpp_file].is_a? String
      return errors.add "options[:cpp_file] should be a string. got #{options.to_h[:cpp_file].class}"
    end

    return if File.file?(options.to_h[:cpp_file])

    errors.add(:cpp_file, "is not a file")
  end

  def validate_inputs
    return if options.to_h[:inputs_path].all? { |input| File.file?(input) }

    errors.add(:base, "not all inputs are files: [#{options.to_h[:inputs_path].join(', ')}]")
  end

  def validate_outputs
    return if options.to_h[:outputs_path].all? { |output| File.file?(output) }

    errors.add(:base, "not all outputs are files: [#{options.to_h[:outputs_path].join(', ')}]")
  end
end