# frozen_string_literal: true

require_relative 'modules/dictionary_metadata'

module LittleWeasel
  module Services
    class MaxInvalidWordsByteSizeService
      METADATA_KEY = :'$$max_invalid_words_bytesize$$'

      include Modules::DictionaryMetadata

      def initialize(dictionary_words_hash)
        self.dictionary_words_hash = dictionary_words_hash
        self.current_bytesize = 0
      end

      def execute
        return build_return unless max_invalid_words_bytesize?

        self.current_bytesize = dictionary_words_hash.reduce(0) do |bytesize, word_and_found|
          unless word_and_found.last
            bytesize += word_and_found.first.bytesize
            break unless bytesize < max_invalid_words_bytesize
          end
          bytesize
        end
        build_return
      end

      def metadata
        self.class.metadata_for(dictionary_words_hash)[METADATA_KEY]
      end

      def refresh!
        # TODO: Implement this
        # self.class.refresh_metadata! dictionary_words_hash
        raise NotImplementedError
      end

      private

      attr_accessor :current_bytesize, :word, :dictionary_words_hash

      def build_return
        exceeded = max_invalid_words_bytesize? &&
                   current_bytesize > max_invalid_words_bytesize
        {
          max_invalid_words_bytesize:
            {
              on?: max_invalid_words_bytesize?,
              off?: !max_invalid_words_bytesize?,
              value: max_invalid_words_bytesize,
              value_exceeded?: exceeded,
              current_invalid_word_bytesize: current_bytesize,
              cache_invalid_words?: max_invalid_words_bytesize? && !exceeded
            }
        }
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
