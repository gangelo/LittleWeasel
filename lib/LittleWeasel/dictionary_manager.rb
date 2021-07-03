# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'dictionary_key'
require_relative 'modules/dictionary_key_validatable'

module LittleWeasel
  # This class provides dictionary management functionality.
  class DictionaryManager
    include Modules::DictionaryKeyValidatable

    attr_reader :dictionary_cache, :dictionary_metadata

    def initialize
      self.dictionary_cache = {}
      self.dictionary_metadata = {}
      init
    end

    def dictionary_for(dictionary_key:)
      validate_dictionary_key dictionary_key: dictionary_key

      unless dictionary_cache_service(dictionary_key: dictionary_key).dictionary_exists?
        # TODO: Raise an error or let the service handle it?
      end

      dictionary_cache_service(dictionary_key: dictionary_key).dictionary_object!
    end

    # Adds a dictionary file source, creates the dictionary and returns the
    # Dictionary object.
    def create_dictionary_from_file(dictionary_key:, file:, word_filters: nil, word_preprocessors: nil)
      validate_dictionary_key dictionary_key: dictionary_key

      dictionary_creator_service(dictionary_key: dictionary_key, word_filters: word_filters,
        word_preprocessors: word_preprocessors).from_file_source file: file
    end

    # Adds a dictionary memory source, creates the dictionary and returns the
    # Dictionary object.
    def create_dictionary_from_memory(dictionary_key:, dictionary_words:, word_filters: nil, word_preprocessors: nil)
      validate_dictionary_key dictionary_key: dictionary_key

      dictionary_creator_service(dictionary_key: dictionary_key, word_filters: word_filters,
        word_preprocessors: word_preprocessors).from_memory_source dictionary_words: dictionary_words
    end

    # Removes any and all traces of the dictionary associated with the
    # dictionary key from the dictionary cache - the Dictionary object, file
    # reference and any metadata associated with the dictionary are completely
    # removed from the dictionary cache.
    def kill_dictionary(dictionary_key:)
      validate_dictionary_key dictionary_key: dictionary_key

      dictionary_killer_service(dictionary_key: dictionary_key).execute
      self
    end

    # Resets the cache and metadata by clearing it out completely.
    def init
      Services::DictionaryCacheService.init dictionary_cache: dictionary_cache
      Services::DictionaryMetadataService.init dictionary_metadata: dictionary_metadata
      self
    end

    private

    attr_writer :dictionary_cache, :dictionary_metadata

    def dictionary_cache_service(dictionary_key:)
      Services::DictionaryCacheService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
    end

    def dictionary_creator_service(dictionary_key:, word_filters:, word_preprocessors:)
      Services::DictionaryCreatorService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
        dictionary_metadata: dictionary_metadata, word_filters: word_filters,
        word_preprocessors: word_preprocessors
    end

    def dictionary_killer_service(dictionary_key:)
      Services::DictionaryKillerService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
        dictionary_metadata: dictionary_metadata
    end
  end
end
