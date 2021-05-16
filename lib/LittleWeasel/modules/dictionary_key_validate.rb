# frozen_string_literal: true

require_relative '../dictionaries/dictionary_key'

module LittleWeasel
  module Modules
    # Validates a dictionary key.
    module DictionaryKeyValidate
      def validate_dictionary_key
        raise ArgumentError, 'Argument dictionary_key is not a DictionaryKey object' \
          unless dictionary_key.is_a? Dictionaries::DictionaryKey
      end
    end
  end
end
