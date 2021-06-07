# frozen_string_literal: true

require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_cache_keys'

module LittleWeasel
  module Services
    # This service unloads a dictionary (Dictionary object) associated with
    # the dictionary key from the dictionary cache; however, the dictionary
    # file reference and any metadata associated with the dictionary are
    # maintained in the dictionary cache.
    class DictionaryUnloaderService
      include Modules::DictionaryCacheKeys
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryKeyable

      def initialize(dictionary_key:, dictionary_cache:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache
      end

      def execute
        unless dictionary_cache_service.dictionary_reference?
          raise ArgumentError,
            "The dictionary reference associated with key '#{key}' could not be found."
        end

        unless dictionary_cache_service.dictionary_loaded?
          raise ArgumentError,
            "The dictionary is not loaded/cached for key '#{key}'."
        end

        unload_dictionary
      end

      private

      def unload_dictionary
        dictionary_id = dictionary_cache_service.dictionary_id!
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id][DICTIONARY_OBJECT] = nil
      end
    end
  end
end
