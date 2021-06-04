# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a dictionary cache object.
    module DictionaryCacheValidate
      def validate_dictionary_cache
        raise ArgumentError, 'Argument dictionary_cache is not a valid Hash' \
          unless dictionary_cache.is_a? Hash
      end
    end
  end
end
