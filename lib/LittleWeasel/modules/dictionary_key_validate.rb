# frozen_string_literal: true

require_relative '../dictionaries/dictionary_key'

module LittleWeasel
  module Modules
    # Validates a dictionary key.
    module DictionaryKeyValidate
      def self.included(base)
        base.extend ClassMethods
      end

      def validate_dictionary_key
        self.class.validate_dictionary_key dictionary_key: dictionary_key
      end

      module ClassMethods
        def validate_dictionary_key(dictionary_key:)
          raise ArgumentError, 'Argument dictionary_key is not a DictionaryKey object' \
            unless dictionary_key.is_a? Dictionaries::DictionaryKey
        end
      end
    end
  end
end
