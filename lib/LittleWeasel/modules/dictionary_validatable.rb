# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides validations related to dictionaries in
    # the dictionary cache.
    module DictionaryValidatable
      module_function

      def validate_dictionary_source_does_not_exist(dictionary_cache_service:)
        # If a dictionary_reference exists, the dictionary_source must exist.
        if dictionary_cache_service.dictionary_reference?
          raise "The dictionary source associated with key '#{dictionary_cache_service.key}' already exists."
        end
      end

      def validate_dictionary_does_not_exist(dictionary_cache_service:)
        if dictionary_cache_service.dictionary_exists?
          raise "The dictionary associated with key '#{dictionary_cache_service.key}' already exists."
        end
      end

      def validate_dictionary_reference_does_not_exist(dictionary_cache_service:)
        if dictionary_cache_service.dictionary_reference?
          raise "A dictionary reference associated with key '#{dictionary_cache_service.key}' already exists."
        end
      end
    end
  end
end
