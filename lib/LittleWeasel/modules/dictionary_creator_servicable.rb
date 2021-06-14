# frozen_string_literal: true

require_relative '../dictionary_key'
require_relative '../services/dictionary_cache_service'
require_relative '../filters/word_filters_validatable'

module LittleWeasel
  module Modules
    module DictionaryCreatorServicable
      include DictionaryKeyable
      include Filters::WordFiltersValidatable

      attr_reader :dictionary_cache, :dictionary_key, :file, :word_filters

      def dictionary_creator_service
        Services::DictionaryCreatorService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
          dictionary_metadata: dictionary_metadata, file: file, word_filters: word_filters)
      end

      private

      attr_writer :dictionary_cache, :dictionary_key, :file, :word_filters
    end
  end
end
