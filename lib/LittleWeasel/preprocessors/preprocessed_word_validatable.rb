# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    # This module validates preprocessed word types.
    module PreprocessedWordValidatable
      def self.validate(preprocessed_word:)
        error_messages = []
        error_messages.concat validate_methods(preprocessed_word: preprocessed_word)
        raise ArgumentError, "Argument preprocessed_word: #{error_messages.join('; ')}" if error_messages.present?
      end

      # rubocop: disable Layout/LineLength
      def self.validate_methods(preprocessed_word:)
        error_messages = []
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#original_word') unless preprocessed_word.respond_to?(:original_word)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#original_word=') unless preprocessed_word.respond_to?(:original_word=)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessed_word') unless preprocessed_word.respond_to?(:preprocessed_word)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessed_word=') unless preprocessed_word.respond_to?(:preprocessed_word=)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessed') unless preprocessed_word.respond_to?(:preprocessed)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessed=') unless preprocessed_word.respond_to?(:preprocessed=)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessed?') unless preprocessed_word.respond_to?(:preprocessed?)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessor') unless preprocessed_word.respond_to?(:preprocessor)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessor=') unless preprocessed_word.respond_to?(:preprocessor=)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessor_order') unless preprocessed_word.respond_to?(:preprocessor_order)
        error_messages << validation_error_message(object: preprocessed_word.class, respond_to: '#preprocessor_order=') unless preprocessed_word.respond_to?(:preprocessor_order=)
        error_messages
      end
      # rubocop: enable Layout/LineLength

      def self.validation_error_message(object:, respond_to:)
        "does not respond to: #{object}#{respond_to}"
      end

      def validate_prepreprocessed_word(preprocessed_word:)
        PreprocessedWordValidatable.validate preprocessed_word: preprocessed_word
      end
    end
  end
end
