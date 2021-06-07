# frozen_string_literal: true

require_relative '../dictionary_key'
require_relative '../services/dictionary_metadata_service'
require_relative 'dictionary_cache_validatable'
require_relative 'dictionary_metadata_validatable'

module LittleWeasel
  module Modules
    module DictionaryMetadataServicable
      include DictionaryKeyable
      include DictionaryCacheValidatable
      include DictionaryMetadataValidatable

      private

      attr_accessor :dictionary_cache, :dictionary_key, :dictionary_metadata

      def dictionary_metadata_service
        Services::DictionaryMetadataService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata)
      end
    end
  end
end
