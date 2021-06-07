# frozen_string_literal: true

require_relative '../dictionary_key'
require_relative '../services/dictionary_cache_service'
require_relative 'dictionary_cache_validatable'

module LittleWeasel
  module Modules
    module DictionaryCacheServicable
      include DictionaryKeyable
      include DictionaryCacheValidatable

      attr_reader :dictionary_cache, :dictionary_key

      def dictionary_cache_service
        Services::DictionaryCacheService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
      end

      private

      attr_writer :dictionary_cache, :dictionary_key
    end
  end
end
