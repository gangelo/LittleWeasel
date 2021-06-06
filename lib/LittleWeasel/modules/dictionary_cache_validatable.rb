# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a dictionary cathe object.
    module DictionaryCacheValidatable
      def validate_dictionary_cache
        raise ArgumentError, "Argument dictionary_cache is not a valid Hash: #{dictionary_cache.class}" \
          unless dictionary_cache.is_a? Hash
      end
    end
  end
end
