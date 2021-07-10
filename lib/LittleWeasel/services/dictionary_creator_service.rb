# frozen_string_literal: true

require_relative '../dictionary'
require_relative '../filters/word_filterable'
require_relative '../filters/word_filters_validatable'
require_relative '../metadata/dictionary_metadata'
require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_creator_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_metadata_servicable'
require_relative '../modules/dictionary_sourceable'
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
      include Modules::DictionarySourceable
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
        add_dictionary_file_source file: file
        dictionary_words = dictionary_file_loader_service.execute
        create_dictionary dictionary_words: dictionary_words
      end

      def from_memory_source(dictionary_words:)
        add_dictionary_memory_source
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

      # Adds a dictionary file source. A "file source" is a file path that
      # indicates that the dictionary words associated with this dictionary are
      # located on disk. This file path is used to locate and load the
      # dictionary words into the dictionary cache for use.
      #
      # @param file [String] a file path pointing to the dictionary file to load and use.
      #
      # @return returns a reference to self.
      def add_dictionary_file_source(file:)
        dictionary_cache_service.add_dictionary_source(dictionary_source: file)
      end

      # Adds a dictionary memory source. A "memory source" indicates that the
      # dictionary words associated with this dictionary were created
      # dynamically and will be located in memory, as opposed to loaded from
      # a file on disk.
      #
      # @return returns a reference to self.
      def add_dictionary_memory_source
        dictionary_cache_service.add_dictionary_source(dictionary_source: memory_source)
      end
    end
  end
end
