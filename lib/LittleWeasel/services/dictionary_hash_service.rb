# frozen_string_literal: true

require_relative 'invalid_words_bytesize_service'

module LittleWeasel
  module Services
    # This class receives an Array of words and returns
    # a Hash of the words.
    class DictionaryHashService
      def initialize(dictionary_words)
        self.dictionary_words = dictionary_words
      end

      def execute
        Hash.new do |words_hash, word_key|
          if found? word_key
            words_hash[word_key] = true
          else
            results = InvalidWordsByteSizeService.new(word_key, words_hash).execute
            words_hash[word_key] = false if results.ok_to_cache_invalid_word?
            false
          end
        end
      end

      private

      def found?(word)
        dictionary_words.include?(word)
      end

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
