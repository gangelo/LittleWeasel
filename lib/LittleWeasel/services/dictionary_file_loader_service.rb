# frozen_string_literal: true

require_relative '../modules/configurable'
require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_file_loader'
require_relative '../modules/dictionary_keyable'

module LittleWeasel
  module Services
    # This class provides a service for loading dictionaries from disk and
    # returning a Hash of dictionary words that can be used to instantiate
    # a Dictionary object or otherwise.
    class DictionaryFileLoaderService
      include Modules::Configurable
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryFileLoader
      include Modules::DictionaryKeyable

      def initialize(dictionary_key:, dictionary_cache:)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache
      end

      def execute
        if dictionary_cache_service.dictionary_exists?
          raise ArgumentError,
            "The dictionary associated with key '#{key}' already exists."
        end

        load dictionary_cache_service.dictionary_file!
      end
    end
  end
end
