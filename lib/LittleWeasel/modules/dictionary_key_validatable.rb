# frozen_string_literal: true

require_relative '../dictionary_key'

module LittleWeasel
  module Modules
    # Provides methods to validate a dictionary key object.
    module DictionaryKeyValidatable
      def validate_dictionary_key
        raise ArgumentError, "Argument dictionary_key is not a valid DictionaryKey object: #{dictionary_key.class}" \
          unless dictionary_key.is_a? DictionaryKey
      end
    end
  end
end
