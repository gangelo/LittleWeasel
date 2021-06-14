# frozen_string_literal: true

require_relative '../dictionary'
require_relative '../filters/word_filters_validatable'
require_relative '../filters/word_filterable'
require_relative '../metadata/dictionary_metadata'
require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_creator_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_metadata_servicable'
require_relative 'dictionary_file_loader_service'

module LittleWeasel
  module Services
    # This class provides services to load dictionaries from either disk or
    # cache.
    class DictionaryCreatorService
      include Filters::WordFilterable
      include Filters::WordFiltersValidatable
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryKeyable
      include Modules::DictionaryMetadataServicable

      def initialize(dictionary_key:, dictionary_cache:, dictionary_metadata:, file:, word_filters: nil)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache

        validate_dictionary_metadata dictionary_metadata: dictionary_metadata
        self.dictionary_metadata = dictionary_metadata

        validate_word_filters word_filters: word_filters unless word_filters.blank?
        self.word_filters = word_filters

        self.file = file
      end

      def execute
        dictionary_cache_service.add_dictionary_reference(file: file)
        dictionary_words = dictionary_file_loader_service.execute
        dictionary = Dictionary.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
          dictionary_metadata: dictionary_metadata, dictionary_words: dictionary_words, word_filters: word_filters)
        dictionary_cache_service.dictionary_object = dictionary
      end

      private

      attr_accessor :file

      def dictionary_file_loader_service
        Services::DictionaryFileLoaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
      end
    end
  end
end
