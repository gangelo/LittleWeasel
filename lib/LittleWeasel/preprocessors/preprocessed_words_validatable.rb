# frozen_string_literal: true

require_relative 'preprocessed_word_validatable'

module LittleWeasel
  module Preprocessors
    # This module provides methods to validate preprocessed words types.
    # rubocop: disable Layout/LineLength
    module PreprocessedWordsValidatable
      module_function

      def validate_prepreprocessed_words(preprocessed_words:)
        raise ArgumentError, validation_error_message(object: preprocessed_words, respond_to: :original_word) unless preprocessed_words.respond_to? :original_word
        raise ArgumentError, validation_error_message(object: preprocessed_words, respond_to: :preprocessed_words) unless preprocessed_words.respond_to? :preprocessed_words

        preprocessed_words&.preprocessed_words&.each do |preprocessed_word|
          PreprocessedWordValidatable.validate_prepreprocessed_word preprocessed_word: preprocessed_word
        end
      end

      def validation_error_message(object:, respond_to:)
        "Argument preprocessed_words does not respond to: #{object.class}##{respond_to}"
      end
    end
    # rubocop: enable Layout/LineLength
  end
end
