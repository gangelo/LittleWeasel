# frozen_string_literal: true

=begin
require_relative '../dictionary_key'
require_relative '../modules/configurable'
require_relative '../modules/dictionary_cache_validatable'
require_relative '../modules/dictionary_metadata_validatable'
require_relative '../modules/dictionary_key_validate'
require_relative 'dictionary_cache_service'
require_relative 'dictionary_metadata_service'

module LittleWeasel
  module Services
    # This class provides a base class for services that manage and
    # manipulate Dictionary objects.
    class DictionaryServiceDeprecated
      include Modules::Configurable
      include Modules::DictionaryCacheValidatable
      include Modules::DictionaryMetadataValidatable
      include Modules::DictionaryKeyValidate

      delegate :key, to: :dictionary_key

      def initialize(dictionary_key:, dictionary_cache:, dictionary_metadata:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache

        self.dictionary_metadata = dictionary_metadata
        validate_dictionary_metadata
      end

      private

      attr_accessor :dictionary_cache, :dictionary_key, :dictionary_metadata

      def dictionary_cache_service
        Services::DictionaryCacheService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
      end

      def dictionary_metadata_service
        Services::DictionaryMetadaService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata)
      end
    end
  end
end
=end
