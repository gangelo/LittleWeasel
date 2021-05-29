# frozen_string_literal: true

require_relative 'language'
require_relative 'region'

module LittleWeasel
  module Modules
    # This module provides methods to handle conversion of
    # parts of a locale to their string counter parts.
    module Locale
      def self.included(base)
        base.extend(LocaleClassMethods)
        base.include(Language)
        base.include(Region)
      end

      module LocaleClassMethods
        def locale(language:, region: nil)
          raise ArgumentError, 'Argument language does not respond to :downcase' unless language.respond_to? :downcase
          raise ArgumentError, 'Argument region does not respond to :upcase' if region.present? && !region.respond_to?(:upcase)

          language = normalize_language language
          return language.to_s unless region.present?

          region = normalize_region region
          "#{language}-#{region}"
        end
      end

      def locale
        self.class.locale language: language, region: region
      end
    end
  end
end