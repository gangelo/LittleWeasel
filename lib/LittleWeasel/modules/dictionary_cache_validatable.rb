# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a dictionary cache object.
    # A dictionary cache object is a container that holds cached data
    # related to one or more dictionaries. Dictionary cache objects are
    # normally specific to a DictionaryManager object.
    module DictionaryCacheValidatable
      module_function

      def validate_dictionary_cache(dictionary_cache:)
        raise ArgumentError, "Argument dictionary_cache is not a valid Hash object: #{dictionary_cache.class}" \
          unless dictionary_cache.is_a? Hash
      end
    end
  end
end
