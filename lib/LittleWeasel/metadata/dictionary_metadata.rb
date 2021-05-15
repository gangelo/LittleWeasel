
module LittleWeasel
  module Metadata
    class DictionaryMetadata
      DICTIONARY_METADATA_KEY = :'$$root$$'

      def initialize(dictionary_words_hash)
        self.dictionary_words_hash = dictionary_words_hash
      end

      def metadata
        dictionary_words_hash[METADATA_ROOT_KEY] || refresh_metadata!
      end

      def refresh!
        metadata = dictionary_words_hash[METADATA_ROOT_KEY] = {}
        #TODO: Notify observers passing metadata
      end

      class << self
        def metadata_for(dictionary_words_hash)
          dictionary_words_hash[METADATA_ROOT_KEY] || refresh_metadata!(dictionary_words_hash)
        end

        def refresh_metadata!(dictionary_words_hash)
          metadata = dictionary_words_hash[METADATA_ROOT_KEY] = {}
          metadata.merge! Services::MaxInvalidWordsByteSizeService.new(dictionary_words_hash).execute
        end
      end

      private

      attr_accessor :dictionary_words_hash
    end
  end
end
