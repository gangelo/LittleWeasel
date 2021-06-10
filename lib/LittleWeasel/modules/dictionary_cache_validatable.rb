# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a dictionary cache object.
    module DictionaryCacheValidatable
      def self.validate(dictionary_cache:)
        raise ArgumentError, "Argument dictionary_cache is not a valid Hash object: #{dictionary_cache.class}" \
          unless dictionary_cache.is_a? Hash
      end

      def validate_dictionary_cache(dictionary_cache:)
        DictionaryCacheValidatable.validate dictionary_cache: dictionary_cache
      end
    end
  end
end
