# frozen_string_literal: true

require_relative '../dictionary_key'

module LittleWeasel
  module Modules
    # Provides methods to validate a dictionary key object.
    module DictionaryKeyValidate
      def self.included(base)
        base.extend ClassMethods
      end

      # class method inclusions for convenience.
      module ClassMethods
        def validate_dictionary_key(dictionary_key:)
          raise ArgumentError, 'Argument dictionary_key is not a DictionaryKey object' \
            unless dictionary_key.is_a? DictionaryKey
        end
      end

      def validate_dictionary_key
        self.class.validate_dictionary_key dictionary_key: dictionary_key
      end
    end
  end
end
