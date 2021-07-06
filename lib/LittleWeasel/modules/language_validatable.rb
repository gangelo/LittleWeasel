# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a language.
    module LanguageValidatable
      module_function

      def validate_language(language:)
        raise ArgumentError, "Argument language '#{language}' is not a Symbol." unless language.is_a? Symbol
      end
    end
  end
end
