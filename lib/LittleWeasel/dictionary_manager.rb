# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'singleton'
require_relative 'dictionaries/dictionary_key'
require_relative 'services/dictionary_service'

module LittleWeasel
  # This class provides dictionary management functionality.
  class DictionaryManager
    include Singleton

    delegate :count, to: :dictionary_cache_service

    def initialize
      reset
    end

    # TODO: Add a load: true argument that loads and returns
    # the newly added dictionary if true?
    def add(dictionary_key:, file:)
      key = validate_and_return_key dictionary_key

      dictionary_cache_service.add(key: key, file: file)
      self
    end

    def load(dictionary_key:)
      dictionary_loader_service(dictionary_key: dictionary_key).execute
    end

    def unload(dictionary_key:)
      key = validate_and_return_key dictionary_key

      raise 'TODO: Implement this'
      self
    end

    def kill(dictionary_key:)
      key = validate_and_return_key dictionary_key

      raise 'TODO: Implement this'
      self
    end

    # Resets the cache by clearing it out completely.
    def reset
      dictionary_cache_service.reset!
      self
    end

    private

    attr_writer :dictionary_cache

    def dictionary_cache
      @dictionary_cache ||= {}
    end

    def dictionary_service
      Services::DictionaryService.new dictionary_cache
    end

    def dictionary_loader_service(dictionary_key:)
      Services::DictionaryLoaderService.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
    end
  end
end
