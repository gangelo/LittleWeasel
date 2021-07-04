# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    # This class provides a container for Preprocessors::PreprocessedWord
    # objects.
    class PreprocessedWords
      attr_reader :original_word, :preprocessed_words

      # original_word:String the unsullied word before any preprocessing has
      # been applied to it.
      # preprocessed_words:Array, Preprocessors::PreprocessedWord, an Array
      # of Preprocessors::PreprocessedWord objects that represents the
      # original_word having passed through each successive
      # Preprocessors::WordPreprocessor.
      def initialize(original_word:, preprocessed_words:)
        self.original_word = original_word
        self.preprocessed_words = preprocessed_words
      end

      class << self
        # Returns true if the word was passed through any preprocessing. If
        # this is the case, #preprocessed_word may be different than
        # #original_word.
        def preprocessed?(preprocessed_words:)
          # TODO: Do we need to check for preprocessors where
          # #preprocessed? is true? or does preprocessed_words
          # contain only preprocessed word objects where
          # #preprocessed? is true?
          preprocessed_words.present?
        end

        def preprocessed_word(preprocessed_words:)
          return unless preprocessed? preprocessed_words: preprocessed_words

          preprocessed_words.max_by(&:preprocessor_order).preprocessed_word
        end
      end

      def preprocessed_words=(value)
        value ||= []
        @preprocessed_words = value
      end

      def preprocessed_word
        self.class.preprocessed_word preprocessed_words: preprocessed_words
      end

      # Returns true if the word was preprocessed
      def preprocessed?
        self.class.preprocessed? preprocessed_words: preprocessed_words
      end

      private

      attr_writer :original_word
    end
  end
end
