# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    # This module validates word preprocessor types.
    # rubocop: disable Layout/LineLength
    module WordPreprocessorValidatable
      module_function

      # :reek:ManualDispatch - ignored, this is duck-typing not 'simulated polymorphism'
      # :reek:TooManyStatements - ignored, "too many statements" is easier to understand than arbitrarily breaking all this down into individual methods
      def validate_word_preprocessor(word_preprocessor:)
        # You can use your own word preprocessor types as long as they quack
        # correctly; however, you are responsible for the behavior of these
        # required methods/ attributes. It's probably better to follow the
        # pattern of existing word preprocessor objects and inherit from
        # Preprocessors::WordPreprocessor.

        word_preprocessor_class = word_preprocessor.class

        # class methods
        raise validation_error_message(object: word_preprocessor_class, respond_to: '.preprocess') unless word_preprocessor_class.respond_to?(:preprocess)
        raise validation_error_message(object: word_preprocessor_class, respond_to: '.preprocess?') unless word_preprocessor_class.respond_to?(:preprocess?)

        # instance methods
        raise validation_error_message(object: word_preprocessor_class, respond_to: '#preprocess') unless word_preprocessor.respond_to?(:preprocess)
        raise validation_error_message(object: word_preprocessor_class, respond_to: '#preprocess?') unless word_preprocessor.respond_to?(:preprocess?)
        raise validation_error_message(object: word_preprocessor_class, respond_to: '#preprocessor_off?') unless word_preprocessor.respond_to?(:preprocessor_off?)
        raise validation_error_message(object: word_preprocessor_class, respond_to: '#preprocessor_on') unless word_preprocessor.respond_to?(:preprocessor_on)
        raise validation_error_message(object: word_preprocessor_class, respond_to: '#preprocessor_on=') unless word_preprocessor.respond_to?(:preprocessor_on=)
        raise validation_error_message(object: word_preprocessor_class, respond_to: '#preprocessor_on?') unless word_preprocessor.respond_to?(:preprocessor_on?)
      end
      # rubocop: enable Layout/LineLength

      def validation_error_message(object:, respond_to:)
        "Argument word_preprocessor: does not respond to: #{object}#{respond_to}"
      end

      # def validate_word_preprocessor(word_preprocessor:)
      #   WordPreprocessorValidatable.validate word_preprocessor: word_preprocessor
      # end
    end
  end
end
