# rubocop:disable Naming/FileName
# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

Dir.glob(File.join(__dir__, 'LittleWeasel', '**', '*.rb')).each do |file|
  # Require the file relative to this file's directory
  require_relative file.sub(File.join(__dir__, '/'), '')
end

# rubocop:enable Naming/FileName
