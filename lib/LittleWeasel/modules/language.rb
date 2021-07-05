# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module LittleWeasel
  module Modules
    # Provides methods for normalizing language for a locale.
    module Language
      def language?
        language.present?
      end

      def normalize_language!
        self.language = normalize_language language
      end

      module_function

      def normalize_language(language)
        language&.downcase
      end
    end
  end
end
