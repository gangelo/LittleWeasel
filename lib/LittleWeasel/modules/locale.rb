# frozen_string_literal: true

require_relative 'language'
require_relative 'region'

module LittleWeasel
  module Modules
    # This module provides methods to handle conversion of parts of a locale to
    # their string counter parts.
    module Locale
      def self.included(base)
        base.include(Language)
        base.include(Region)
      end

      def locale
        validate_language_and_region

        language = normalize_language
        return language.to_s unless region.present?

        region = normalize_region
        "#{language}-#{region}"
      end

      # :reek:ManualDispatch, ignored - This is raising an error, not "simulating polymorphism"
      def validate_language_and_region
        raise ArgumentError, 'Argument language does not respond to :downcase' unless language.respond_to? :downcase

        if region.present? && !region.respond_to?(:upcase)
          raise ArgumentError,
            'Argument region does not respond to :upcase'
        end
      end
    end
  end
end
