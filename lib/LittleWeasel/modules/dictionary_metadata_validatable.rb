# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a dictionary metadata object.
    module DictionaryMetadataValidatable
      module_function

      def validate_dictionary_metadata(dictionary_metadata:)
        raise ArgumentError, "Argument dictionary_metadata is not a valid Hash object: #{dictionary_metadata.class}" \
          unless dictionary_metadata.is_a? Hash
      end
    end
  end
end
