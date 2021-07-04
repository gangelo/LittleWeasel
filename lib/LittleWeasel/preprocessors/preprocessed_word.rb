# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    # This class represents a word that has passed through
    # Preprocessor::WordPreprocessor processing. Word preprocessors
    # are used to preprocess a word before it is passed to any
    # Filters::WordFilters, and before it is compared against the
    # dictionary for validity.
    # :reek:Attribute, ignored - Fixing this would result in nothing but trivial setter methods
    class PreprocessedWord
      attr_accessor :original_word, :preprocessed, :preprocessed_word, :preprocessor, :preprocessor_order

      def initialize(original_word:, preprocessed:, preprocessed_word:, preprocessor:, preprocessor_order:)
        self.original_word = original_word
        self.preprocessed_word = preprocessed_word
        self.preprocessed = preprocessed
        self.preprocessor = preprocessor
        self.preprocessor_order = preprocessor_order
      end

      # Returns true if the word was preprocessed; false, if the word
      # was not preprocessed by this preprocessor.
      def preprocessed?
        preprocessed
      end
    end
  end
end
