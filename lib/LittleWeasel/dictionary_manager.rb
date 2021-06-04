# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'singleton'
require_relative 'dictionary_key'
require_relative 'modules/dictionary_key_validate'
require_relative 'services/dictionary_cache_service'

module LittleWeasel
  # This class provides dictionary management functionality.
  class DictionaryManager
    include Singleton
    include Modules::DictionaryKeyValidate

    attr_reader :dictionary_cache

    def initialize
      self.dictionary_cache = {}
      reset!
    end

    def count
      Services::DictionaryCacheService.count dictionary_cache: dictionary_cache
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

    # rubocop: disable Lint/UnusedMethodArgument, Lint/UnreachableCode
    def unload_dictionary(dictionary_key:)
      raise 'TODO: Implement this'
      self
    end

    def kill_dictionary(dictionary_key:)
      raise 'TODO: Implement this'
      self
    end
    # rubocop: enable Lint/UnusedMethodArgument, Lint/UnreachableCode

    # Resets the cache by clearing it out completely.
    def reset!
      Services::DictionaryCacheService.reset! dictionary_cache: dictionary_cache
      self
    end

    private

    attr_writer :dictionary_cache

    def validate_dictionary_key(dictionary_key:)
      self.class.validate_dictionary_key dictionary_key: dictionary_key
    end

    def dictionary_cache_service(dictionary_key:)
      Services::DictionaryCacheService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
    end

    def dictionary_loader_service(dictionary_key:)
      Services::DictionaryLoaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
    end
  end
end
