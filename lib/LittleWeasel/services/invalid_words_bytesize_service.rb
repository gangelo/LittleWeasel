# frozen_string_literal: true

module LittleWeasel
  module Services
    class InvalidWordsByteSizeService
      def initialize(word, words_hash)
        self.word = word
        self.words_hash = words_hash
        self.current_bytesize = 0
      end

      def execute
        return build_return if max_invalid_words_bytesize_off? ||
                               word_exceeds_max_invalid_words_bytesize?

        self.current_bytesize = words_hash.reduce(0) do |bytesize, word_and_found|
          unless word_and_found.last
            bytesize += word_and_found.first.bytesize
            break unless bytesize < max_invalid_words_bytesize
          end
          bytesize
        end
        build_return
      end

      private

      attr_accessor :current_bytesize, :word, :words_hash

      def build_return
        max_bytesize = max_invalid_words_bytesize
        exceeded = max_invalid_words_bytesize_on? &&
                   (current_bytesize > max_bytesize ||
                   word_exceeds_max_invalid_words_bytesize?)
        ok_to_cache_invalid_word = max_invalid_words_bytesize_on? && !exceeded
        OpenStruct.new(current_bytesize: current_bytesize,
          max_bytesize: max_bytesize,
          max_bytesize_exceeded?: exceeded,
          ok_to_cache_invalid_word?: ok_to_cache_invalid_word,
          config_option_on?: max_invalid_words_bytesize_on?,
          config_option_off?: max_invalid_words_bytesize_off?)
      end

      def max_invalid_words_bytesize
        @max_invalid_words_bytesize = config.max_invalid_words_bytesize
      end

      def max_invalid_words_bytesize_on?
        @max_invalid_words_bytesize_on ||= config.max_invalid_words_bytesize.positive?
      end

      def max_invalid_words_bytesize_off?
        !max_invalid_words_bytesize_on?
      end

      def word_exceeds_max_invalid_words_bytesize?
        @word_exceeds_max_invalid_words_bytesize =
          word.bytesize > max_invalid_words_bytesize
      end

      def config
        @config ||= LittleWeasel.configuration
      end
    end
  end
end
