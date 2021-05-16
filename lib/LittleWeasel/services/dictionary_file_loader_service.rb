
require_relative '../modules/dictionary_file_loader'
require_relative 'dictionary_service'

module LittleWeasel
  module Services
    class DictionaryFileLoaderService < DictionaryService
      include Modules::DictionaryFileLoader

      def execute
        if dictionary_cache_service.dictionary_loaded?
          raise ArgumentError, "The Dictionary associated with argument key '#{key}' has been loaded and cached; load it from the cache instead."
        end

        load dictionary_cache_service.dictionary_file!
      end
    end
  end
end
