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
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache
      end

      def execute
        dictionary_cache_service.unload_dictionary
      end
    end
  end
end
