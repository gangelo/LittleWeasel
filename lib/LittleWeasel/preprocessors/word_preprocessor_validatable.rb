# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    # This module validates word preprocessor types.
    module WordPreprocessorValidatable
      def self.validate(word_preprocessor:)
        error_messages = []

        # You can use your own word preprocessor types as long as they quack
        # correctly; however, you are responsible for the behavior of these
        # required methods/ attributes. It's probably better to follow the
        # pattern of existing word preprocessor objects and inherit from
        # Preprocessors::WordPreprocessor.

        error_messages.concat validate_class_methods(word_preprocessor: word_preprocessor)
        error_messages.concat validate_instance_methods(word_preprocessor: word_preprocessor)

        raise ArgumentError, "Argument word_preprocessor: #{error_messages.join('; ')}" if error_messages.present?
      end

      # rubocop: disable Layout/LineLength
      def self.validate_class_methods(word_preprocessor:)
        error_messages = []
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '.preprocess') unless word_preprocessor.class.respond_to?(:preprocess)
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '.preprocess?') unless word_preprocessor.class.respond_to?(:preprocess?)
        error_messages
      end
      # rubocop: enable Layout/LineLength

      # rubocop: disable Layout/LineLength
      def self.validate_instance_methods(word_preprocessor:)
        error_messages = []
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '#preprocess') unless word_preprocessor.respond_to?(:preprocess)
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '#preprocess?') unless word_preprocessor.respond_to?(:preprocess?)
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '#preprocessor_off?') unless word_preprocessor.respond_to?(:preprocessor_off?)
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '#preprocessor_on') unless word_preprocessor.respond_to?(:preprocessor_on)
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '#preprocessor_on=') unless word_preprocessor.respond_to?(:preprocessor_on=)
        error_messages << validation_error_message(object: word_preprocessor.class, respond_to: '#preprocessor_on?') unless word_preprocessor.respond_to?(:preprocessor_on?)
        error_messages
      end
      # rubocop: enable Layout/LineLength

      def self.validation_error_message(object:, respond_to:)
        "does not respond to: #{object}#{respond_to}"
      end

      def validate_word_preprocessor(word_preprocessor:)
        WordPreprocessorValidatable.validate word_preprocessor: word_preprocessor
      end
    end
  end
end
