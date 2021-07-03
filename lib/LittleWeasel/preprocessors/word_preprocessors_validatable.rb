# frozen_string_literal: true

require_relative 'word_preprocessor_validatable'

module LittleWeasel
  module Preprocessors
    # This module provides methods to validate an Array of word preprocessor
    # objects.
    module WordPreprocessorsValidatable
      module_function

      def validate_word_preprocessors(word_preprocessors:)
        return if word_preprocessors.blank?

        raise ArgumentError, "Argument word_preprocessors is not an Array: #{word_preprocessors.class}" \
          unless word_preprocessors.is_a? Array

        word_preprocessors.each do |word_preprocessor|
          WordPreprocessorValidatable.validate_word_preprocessor word_preprocessor: word_preprocessor
        end
      end
    end
  end
end
