# frozen_string_literal: true

module LittleWeasel
  module Preprocessors
    class PreprocessedWord
      attr_accessor :original_word, :preprocessed, :preprocessed_word, :preprocessor, :preprocessor_order

      def initialize(original_word:, preprocessed:, preprocessed_word:, preprocessor:, preprocessor_order:)
        self.original_word = original_word
        self.preprocessed_word = preprocessed_word
        self.preprocessed = preprocessed
        self.preprocessor = preprocessor
        self.preprocessor_order = preprocessor_order
      end

      # Returns true if the word was preprocessed
      def preprocessed?
        preprocessed
      end
    end
  end
end
