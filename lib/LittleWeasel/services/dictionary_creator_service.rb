# frozen_string_literal: true

require_relative '../dictionary'
require_relative '../filters/word_filterable'
require_relative '../filters/word_filters_validatable'
require_relative '../metadata/dictionary_metadata'
require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_creator_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_metadata_servicable'
require_relative '../preprocessors/word_preprocessor_managable'
require_relative 'dictionary_file_loader_service'

module LittleWeasel
  module Services
    # This class provides a service to load dictionaries from disk, create
    # and return a Dictionary object.
    class DictionaryCreatorService
      include Filters::WordFilterable
      include Filters::WordFiltersValidatable
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryKeyable
      include Modules::DictionaryMetadataServicable
      include Preprocessors::WordPreprocessorManagable

      def initialize(dictionary_key:, dictionary_cache:, dictionary_metadata:,
        word_filters: nil, word_preprocessors: nil)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache

        validate_dictionary_metadata dictionary_metadata: dictionary_metadata
        self.dictionary_metadata = dictionary_metadata

        validate_word_filters word_filters: word_filters unless word_filters.blank?
        self.word_filters = word_filters

        validate_word_preprocessors word_preprocessors: word_preprocessors unless word_preprocessors.blank?
        self.word_preprocessors = word_preprocessors
      end

      def from_file_source(file:)
        dictionary_cache_service.add_dictionary_file_source(file: file)
        dictionary_words = dictionary_file_loader_service.execute
        create_dictionary dictionary_words: dictionary_words
      end

      def from_memory_source(dictionary_words:)
        dictionary_cache_service.add_dictionary_memory_source
        create_dictionary dictionary_words: dictionary_words
      end

      private

      def dictionary_file_loader_service
        Services::DictionaryFileLoaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
      end

      def create_dictionary(dictionary_words:)
        Dictionary.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
          dictionary_metadata: dictionary_metadata, dictionary_words: dictionary_words, word_filters: word_filters,
          word_preprocessors: word_preprocessors).tap do |dictionary|
          dictionary_cache_service.dictionary_object = dictionary
        end
      end
    end
  end
end
