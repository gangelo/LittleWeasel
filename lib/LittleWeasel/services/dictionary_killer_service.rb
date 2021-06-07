# frozen_string_literal: true

require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_metadata_servicable'
require_relative '../modules/dictionary_keyable'

module LittleWeasel
  module Services
    # This service removes a dictionary (Dictionary object) associated with
    # the dictionary key from the dictionary cache along with the dictionary
    # file reference and any metadata associated with the dictionary from the
    # dictionary cache.
    class DictionaryKillerService
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryMetadataServicable
      include Modules::DictionaryKeyable

      def initialize(dictionary_key:, dictionary_cache:, dictionary_metadata:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache

        self.dictionary_metadata = dictionary_metadata
        validate_dictionary_metadata
      end

      def execute
        raise NotImplementedError, "TODO: Implement this!"
      end
    end
  end
end
