# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    # This module validates word preprocessor types.
    module WordPreprocessorValidatable
      def self.validate(word_preprocessor:)
        raise ArgumentError, "Argument word_preprocessor does not quack right: #{word_preprocessor.class}" \
          unless valid_word_preprocessor?(word_preprocessor: word_preprocessor)
      end

      # You can use your own word preprocessor types as long as they quack correctly;
      # however, you are responsible for the behavior of these required methods/
      # attributes. It's probably better to follow the pattern of existing word
      # preprocessor objects and inherit from Preprocessors::WordPreprocessor.
      def self.valid_word_preprocessor?(word_preprocessor:)
        word_preprocessor.respond_to?(:preprocessor_on?) &&
          word_preprocessor.respond_to?(:preprocessor_off?) &&
          word_preprocessor.respond_to?(:preprocessor_on) &&
          word_preprocessor.respond_to?(:preprocessor_on=) &&
          word_preprocessor.respond_to?(:preprocess?) &&
          word_preprocessor.class.respond_to?(:preprocess?) &&
          word_preprocessor.respond_to?(:preprocess) &&
          word_preprocessor.class.respond_to?(:preprocess)
      end

      def validate_word_preprocessor(word_preprocessor:)
        WordPreprocessorValidatable.validate word_preprocessor: word_preprocessor
      end
    end
  end
end
