# frozen_string_literal: true

require_relative '../dictionary_words_hash'

module LittleWeasel
  module Services
    # This class receives an Array of words and returns
    # a Hash of the words.
    class DictionaryHashService
      def initialize(dictionary_words)
        raise ArgumentError unless dictionary_words&.is_a?(Array)

        self.dictionary_words = dictionary_words.dup
      end

      def execute
        # Hash.new do |words_hash, word_key|
        #   binding.pry
        #   dictionary_words_hash = DictionaryWordsHash.new words_hash
        #   _cached, found = dictionary_words_hash.cache_word_if! word_key
        #   found
        # end
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
