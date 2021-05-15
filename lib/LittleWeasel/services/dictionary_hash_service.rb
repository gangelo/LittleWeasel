# frozen_string_literal: true

require_relative '../dictionary_words_hash'

module LittleWeasel
  module Services
    # This class receives an Array of words and returns
    # a Hash of the words.
    class DictionaryHashService
      def initialize(dictionary_words)
        raise ArgumentError unless dictionary_words.is_a?(Array)

        self.dictionary_words = dictionary_words.dup
      end

      def execute
        DictionaryWordsHash.new dictionary_words
      end

      private

      def dictionary_words
        @dictionary_words ||= dictionary_words
      end

      def config
        @config ||= LittleWeasel.configuration
      end

      attr_writer :dictionary_words
    end
  end
end
