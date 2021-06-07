# frozen_string_literal: true

require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_file_loader'

module LittleWeasel
  module Services
    class DictionaryFileLoaderService
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryKeyable
      include Modules::DictionaryFileLoader

      def initialize(dictionary_key:, dictionary_cache:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache
      end

      def execute
        if dictionary_cache_service.dictionary_loaded?
          raise ArgumentError,
            "The Dictionary associated with argument key '#{key}' " \
              'has been loaded and cached; load it from the cache instead.'
        end

        load dictionary_cache_service.dictionary_file!
      end
    end
  end
end
