# frozen_string_literal: true

require_relative '../metadata/invalid_words_service_results'

module LittleWeasel
  module Services
    # This class calculates the total amount of bytes cached invalid words take
    # up in the given dictionary and returns the results. In addition to this,
    # metadata is also compiled to determine how many more bytes of invalid
    # word data can be cached before the cache is depleted and shutdown.
    class InvalidWordsService
      def initialize(dictionary)
        self.dictionary = dictionary
        self.current_bytesize = 0
      end

      def execute
        return build_return unless max_invalid_words_bytesize?

        self.current_bytesize = calculate_current_bytesize
        build_return
      end

      private

      attr_accessor :current_bytesize, :dictionary

      def calculate_current_bytesize
        dictionary.reduce(0) do |bytesize, word_and_found|
          unless word_and_found.last
            bytesize += word_and_found.first.bytesize
            break unless bytesize < max_invalid_words_bytesize
          end
          bytesize
        end
      end

      def build_return
        Metadata::InvalidWordsServiceResults.new(
          max_invalid_words_bytesize_on: max_invalid_words_bytesize?,
          current_invalid_word_bytesize: current_bytesize,
          max_invalid_words_bytesize: max_invalid_words_bytesize
        )
      end

      def max_invalid_words_bytesize
        @max_invalid_words_bytesize ||= config.max_invalid_words_bytesize
      end

      def max_invalid_words_bytesize?
        config.max_invalid_words_bytesize?
      end

      def config
        @config ||= LittleWeasel.configuration
      end
    end
  end
end
