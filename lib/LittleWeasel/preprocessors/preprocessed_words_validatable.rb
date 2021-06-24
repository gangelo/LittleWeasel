# frozen_string_literal: true

require_relative 'preprocessed_word_validatable'

module LittleWeasel
  module Preprocessors
    # This module provides methods to validate preprocessed words types.
    module PreprocessedWordsValidatable
      def self.validate(preprocessed_words:)
        unless preprocessed_words.respond_to? :original_word
          raise ArgumentError,
            validation_error_message(object: preprocessed_words,
            respond_to: :original_word)
        end

        unless preprocessed_words.respond_to? :preprocessed_words
          raise ArgumentError,
            validation_error_message(object: preprocessed_words,
            respond_to: :preprocessed_words)
        end

        error_messages = []
        preprocessed_words&.preprocessed_words&.each do |preprocessed_word|
          PreprocessedWordValidatable.validate_prepreprocessed_word preprocessed_word: preprocessed_word
        end
        raise "Argument preprocessed_words element(s): #{error_messages}" if error_messages.present?
      end

      def self.validation_error_message(object:, respond_to:)
        "Argument preprocessed_words does not respond to: #{object.class}##{respond_to}"
      end

      def validate_prepreprocessed_words(preprocessed_words:)
        PreprocessedWordsValidatable.validate preprocessed_words: preprocessed_words
      end
    end
  end
end
