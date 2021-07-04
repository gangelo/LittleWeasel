# frozen_string_literal: true

require_relative 'language'
require_relative 'region'

module LittleWeasel
  module Modules
    # This module provides methods to handle conversion of parts of a locale to
    # their string counter parts.
    module Locale
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Language)
        base.include(Region)
      end

      # class method inclusions for convenience.
      module ClassMethods
        def locale(language:, region: nil)
          raise ArgumentError, 'Argument language does not respond to :downcase' unless language.respond_to? :downcase

          region_present = region.present?

          if region_present && !region.respond_to?(:upcase)
            raise ArgumentError,
              'Argument region does not respond to :upcase'
          end

          language = normalize_language language
          return language.to_s unless region_present

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
