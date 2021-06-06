# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a dictionary metadata object.
    module DictionaryMetadataValidatable
      def validate_dictionary_metadata
        raise ArgumentError, 'Argument dictionary_metadata is not a valid Hash' \
          unless dictionary_metadata.is_a? Hash
      end
    end
  end
end
