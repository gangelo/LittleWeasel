# frozen_string_literal: true

require_relative 'word_preprocessor_validatable'

module LittleWeasel
  module Preprocessors
    # This module provides methods to validate an Array of word preprocessor
    # objects.
    module WordPreprocessorsValidatable
      extend WordPreprocessorValidatable

      def self.validate(word_preprocessors:)
        return if word_preprocessors.blank?

        unless word_preprocessors.is_a? Array
          raise ArgumentError,
            "Argument word_preprocessors is not an Array: #{word_preprocessors.class}"
        end

        word_preprocessors.each do |word_preprocessor|
          validate_word_preprocessor word_preprocessor: word_preprocessor
        end
      end

      def validate_word_preprocessors(word_preprocessors:)
        WordPreprocessorsValidatable.validate word_preprocessors: word_preprocessors
      end
    end
  end
end
