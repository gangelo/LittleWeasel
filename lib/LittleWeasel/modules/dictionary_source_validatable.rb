# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a dictionary source.
    module DictionarySourceValidatable
      module_function

      def validate_dictionary_source(dictionary_source:)
        raise ArgumentError, 'Argument dictionary_source is not present' \
          unless dictionary_source.present?
      end
    end
  end
end
