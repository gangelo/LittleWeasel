# frozen_string_literal: true

require_relative '../dictionaries/dictionary_key'
require_relative '../modules/configurable'
require_relative '../modules/dictionary_cache_validate'
require_relative '../modules/dictionary_key_validate'
require_relative 'dictionary_cache_service'

module LittleWeasel
  module Services
    # This class provides a base class for services that manage and
    # manipulate Dictionary objects.
    class DictionaryService
      include Modules::Configurable
      include Modules::DictionaryCacheValidate
      include Modules::DictionaryKeyValidate

      delegate :key, to: :dictionary_key

      def initialize(dictionary_key:, dictionary_cache:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache
      end

      private

      attr_accessor :dictionary_cache, :dictionary_key

      def dictionary_cache_service
        Services::DictionaryCacheService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
      end
    end
  end
end
