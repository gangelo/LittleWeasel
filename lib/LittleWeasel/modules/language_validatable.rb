# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a language.
    module LanguageValidatable
      def self.validate(language:)
        raise ArgumentError, "Argument language '#{language}' is not a Symbol." unless language.is_a? Symbol
      end

      def validate_language(language:)
        LanguageValidatable.validate language: language
      end
    end
  end
end
