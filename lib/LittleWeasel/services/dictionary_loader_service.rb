# frozen_string_literal: true

require_relative '../dictionary'
require_relative '../metadata/dictionary_metadata'
require_relative 'dictionary_file_loader_service'
require_relative 'dictionary_service'

module LittleWeasel
  module Services
    # This class provides services to load dictionaries from either disk or
    # cache.
    class DictionaryLoaderService < DictionaryService
      def execute
        if dictionary_cache_service.dictionary_cached?
          dictionary_cache.dictionary_object!
        else
          dictionary_for dictionary_file_loader_service.execute
          # TODO: Add the dictionary to the dictionary cache here?
        end
      end

      private

      def dictionary_for(dictionary_words)
        Dictionary.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
          dictionary_words: dictionary_words
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
