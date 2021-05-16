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
        dictionary = if dictionary_cache_service.dictionary_cached?
          dictionary_cache.dictionary_object!
        else
          dictionary_words = dictionary_file_loader_service.execute
          Dictionary.new dictionary_words: dictionary_words, dictionary_cache: dictionary_cache
        end
        dictionary
      end

      private

      def dictionary_for(dictionary_words)
        Dictionary.new dictionary_words: dictionary_words, dictionary_cache: dictionary_cache
      end

      def dictionary_cache_loader_service
        Services::DictionaryCacheLoaderService.new dictionary_cache
      end

      def dictionary_file_loader_service
        Services::DictionaryFileLoaderService.new dictionary_cache
      end
    end
  end
end
