# frozen_string_literal: true

require_relative '../dictionary_key'
require_relative '../services/dictionary_loader_service'
require_relative 'dictionary_cache_validatable'

module LittleWeasel
  module Modules
    # This module defines methods and attributes to consume the dictionary
    # loader service.
    module DictionaryLoaderServicable
      include DictionaryCacheValidatable
      include DictionaryKeyable

      attr_reader :dictionary_cache, :dictionary_key, :dictionary_metadata

      def dictionary_loader_service
        Services::DictionaryLoaderService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
          dictionary_metadata: dictionary_metadata)
      end

      private

      attr_writer :dictionary_cache, :dictionary_key, :dictionary_metadata
    end
  end
end
