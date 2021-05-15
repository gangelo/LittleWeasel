# frozen_string_literal: true

require_relative '../services/invalid_words_bytesize_service'

module LittleWeasel
  module Modules
    # Defines methods to support DictionaryWordHash medatada.
    module DictionaryWordsHashMetadata
      METADATA_KEY = :'$$metadata$$'

      def self.included(base)
        base.extend ClassMethods
      end

      def metadata
        self.class.metadata_for dictionary_words_hash
      end

      def refresh!
        self.class.refresh_metadata! dictionary_words_hash
      end

      module ClassMethods
        def metadata_for(dictionary_words_hash)
          dictionary_words_hash[METADATA_KEY] || refresh_metadata!(dictionary_words_hash)
        end

        def refresh_metadata!(dictionary_words_hash)
          metadata = dictionary_words_hash[METADATA_KEY] = {}
          metadata.merge! Services::InvalidWordsByteSizeService.new(dictionary_words_hash).execute
        end
      end
    end
  end
end
