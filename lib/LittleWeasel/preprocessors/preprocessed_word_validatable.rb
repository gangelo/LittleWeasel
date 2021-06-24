# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    # This module provides functionality that validates preprocessed word types.
    # rubocop: disable Layout/LineLength
    module PreprocessedWordValidatable
      module_function

      def validate_prepreprocessed_word(preprocessed_word:)
        validate_original_word preprocessed_word: preprocessed_word
        validate_preprocessed_word preprocessed_word: preprocessed_word
        validate_preprocessed preprocessed_word: preprocessed_word
        validate_preprocessor preprocessed_word: preprocessed_word
        validate_preprocessor_order preprocessed_word: preprocessed_word
      end

      def validation_error_message(object:, respond_to:)
        "Argument preprocessed_word: does not respond to: #{object}#{respond_to}"
      end

      def validate_original_word(preprocessed_word:)
        preprocessed_word_class = preprocessed_word.class
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#original_word') unless preprocessed_word.respond_to?(:original_word)
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#original_word=') unless preprocessed_word.respond_to?(:original_word=)
      end

      def validate_preprocessed_word(preprocessed_word:)
        preprocessed_word_class = preprocessed_word.class
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessed_word') unless preprocessed_word.respond_to?(:preprocessed_word)
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessed_word=') unless preprocessed_word.respond_to?(:preprocessed_word=)
      end

      def validate_preprocessed(preprocessed_word:)
        preprocessed_word_class = preprocessed_word.class
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessed') unless preprocessed_word.respond_to?(:preprocessed)
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessed=') unless preprocessed_word.respond_to?(:preprocessed=)
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessed?') unless preprocessed_word.respond_to?(:preprocessed?)
      end

      def validate_preprocessor(preprocessed_word:)
        preprocessed_word_class = preprocessed_word.class
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessor') unless preprocessed_word.respond_to?(:preprocessor)
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessor=') unless preprocessed_word.respond_to?(:preprocessor=)
      end

      def validate_preprocessor_order(preprocessed_word:)
        preprocessed_word_class = preprocessed_word.class
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessor_order') unless preprocessed_word.respond_to?(:preprocessor_order)
        raise validation_error_message(object: preprocessed_word_class, respond_to: '#preprocessor_order=') unless preprocessed_word.respond_to?(:preprocessor_order=)
      end
    end
    # rubocop: enable Layout/LineLength
  end
end
