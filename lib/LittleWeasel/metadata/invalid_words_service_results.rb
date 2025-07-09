# frozen_string_literal: true

module LittleWeasel
  module Metadata
    # This class provides a container for the results of the
    # InvalidWordsService service.
    class InvalidWordsServiceResults
      attr_accessor :current_invalid_word_bytesize
      attr_reader :max_invalid_words_bytesize

      def initialize(max_invalid_words_bytesize_on:,
        current_invalid_word_bytesize:, max_invalid_words_bytesize:)
        self.max_invalid_words_bytesize_on = max_invalid_words_bytesize_on
        self.current_invalid_word_bytesize = current_invalid_word_bytesize
        self.max_invalid_words_bytesize = max_invalid_words_bytesize
      end

      def on?
        max_invalid_words_bytesize_on
      end

      def off?
        !on?
      end

      def value
        max_invalid_words_bytesize
      end

      def value_exceeded?
        on? && current_invalid_word_bytesize > max_invalid_words_bytesize
      end

      def cache_invalid_words?
        on? && !value_exceeded?
      end

      private

      attr_accessor :max_invalid_words_bytesize_on
      attr_writer :max_invalid_words_bytesize
    end
  end
end
