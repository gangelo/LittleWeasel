# frozen_string_literal: true

module LittleWeasel
  module Modules
    # Provides methods for normalizing language for a locale
    module Language
      def self.included(base)
        base.extend(LanguageClassMethods)
      end

      module LanguageClassMethods
        def normalize_language(language)
          language&.downcase
        end
      end

      def normalize_language
        self.class.normalize_language language
      end
    end
  end
end
