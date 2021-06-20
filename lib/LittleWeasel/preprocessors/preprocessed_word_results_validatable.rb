# frozen_string_literal: true

require_relative 'preprocessed_word_validatable'

module LittleWeasel
  module Preprocessors
    # This module validates preprocessed word result types.
    module PreprocessedWordResultsValidatable
      def self.validate(preprocessed_word_results:)
        unless preprocessed_word_results.respond_to? :original_word
          raise ArgumentError,
            validation_error_message(object: preprocessed_word_results,
respond_to: :original_word)
        end
        unless preprocessed_word_results.respond_to? :preprocessed_words
          raise ArgumentError,
            validation_error_message(object: preprocessed_word_results,
respond_to: :preprocessed_words)
        end

        error_messages = []
        preprocessed_word_results&.preprocessed_words&.each do |preprocessed_word|
          error_messages.concat PreprocessedWordValidatable.validate_methods preprocessed_word: preprocessed_word
        end
        raise "Argument preprocessed_word_results element(s): #{error_messages}" if error_messages.present?
      end

      def self.validation_error_message(object:, respond_to:)
        "Argument preprocessed_word_results does not respond to: #{object.class}##{respond_to}"
      end

      def validate_prepreprocessed_word_results(preprocessed_word_results:)
        PreprocessedWordResultsValidatable.validate preprocessed_word_results: preprocessed_word_results
      end
    end
  end
end
