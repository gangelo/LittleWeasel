# frozen_string_literal: true

require_relative '../dictionary'
require_relative '../metadata/dictionary_metadata'
require_relative '../modules/dictionary_cache_servicable'
rquire_relative '../modules/dictionary_medatata_verifiable'
require_relative '../modules/dictionary_keyable'
require_relative 'dictionary_file_loader_service'

module LittleWeasel
  module Services
    # This class provides services to load dictionaries from either disk or
    # cache.
    class DictionaryLoaderService
      include Modules::DictionaryKeyable
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryMetadataVerifiable

      def initialize(dictionary_key:, dictionary_cache:, dictionary_metadata:)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache

        validate_dictionary_metadata dictionary_metadata: dictionary_metadata
        self.dictionary_metadata = dictionary_metadata
      end

      def execute
        if dictionary_cache_service.dictionary_cached?
          load_from_cache
        else
          load_from_disk
        end
      end

      private

      def load_from_cache
        dictionary_cache_service.dictionary_object!
      end

      def load_from_disk
        dictionary_for dictionary_words: dictionary_file_loader_service.execute
      end

      def dictionary_for(dictionary_words:)
        Dictionary.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
          dictionary_metadata: dictionary_metadata, dictionary_words: dictionary_words
      end

      def dictionary_cache_loader_service
        Services::DictionaryCacheLoaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
      end

      def dictionary_file_loader_service
        Services::DictionaryFileLoaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
      end
    end
  end
end
