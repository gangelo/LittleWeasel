# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'dictionary_key'
require_relative 'modules/dictionary_key_validatable'

require_relative 'modules/dictionary_creator_servicable'

module LittleWeasel
  # This class provides dictionary management functionality.
  class DictionaryManager
    include Modules::DictionaryKeyValidatable
    include Modules::DictionaryCreatorServicable

    attr_reader :dictionary_cache, :dictionary_metadata

    def initialize
      self.dictionary_cache = {}
      self.dictionary_metadata = {}
      init
    end

    def add_dictionary_reference(dictionary_key:, file:)
      validate_dictionary_key dictionary_key: dictionary_key

      dictionary_cache_service(dictionary_key: dictionary_key).add_dictionary_reference(file: file)
      self
    end

    def load_dictionary(dictionary_key:)
      validate_dictionary_key dictionary_key: dictionary_key

      dictionary_loader_service(dictionary_key: dictionary_key).execute
    end

    # Adds a dictionary reference, creates the dictionary and returns the
    # Dictionary object.
    def create_dictionary(dictionary_key:, file:, word_filters: nil)
      validate_dictionary_key dictionary_key: dictionary_key

      dictionary_creator_service(dictionary_key: dictionary_key, file: file, word_filters: word_filters).execute
    end

    # Unloads the dictionary (Dictionary object) associated with the dictionary
    # key from the dictionary cache; however, the dictionary file reference
    # and any metadata associated with the dictionary are maintained in the
    # dictionary cache.
    def unload_dictionary(dictionary_key:)
      validate_dictionary_key dictionary_key: dictionary_key

      dictionary_unloader_service(dictionary_key: dictionary_key).execute
      self
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

    def dictionary_creator_service(dictionary_key:, file:, word_filters:)
      Services::DictionaryCreatorService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
        dictionary_metadata: dictionary_metadata, file: file, word_filters: word_filters
    end

    def dictionary_cache_service(dictionary_key:)
      Services::DictionaryCacheService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
    end

    def dictionary_loader_service(dictionary_key:)
      Services::DictionaryLoaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
        dictionary_metadata: dictionary_metadata
    end

    def dictionary_unloader_service(dictionary_key:)
      Services::DictionaryUnloaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
    end

    def dictionary_killer_service(dictionary_key:)
      Services::DictionaryKillerService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache,
        dictionary_metadata: dictionary_metadata
    end
  end
end
