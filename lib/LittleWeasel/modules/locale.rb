# frozen_string_literal: true

require_relative '../errors/language_required_error'

module LittleWeasel
  module Modules
    # This module provides methods to handle conversion of
    # parts of a locale to their string counter parts.
    module Locale
      # Returns the locale based on what locale parts are
      # availabe, for example:
      #
      # If language and region are available, the following is returned:
      #
      # Given language: :en, region: :us
      # #=> "en-US"
      #
      # Given language: :en
      # #=> "en"
      #
      # Given language and region undefined
      # #=> ""
      def locale
        if defined?(language) && defined?(region)
          locale_from language: language, region: region
        elsif defined?(language)
          locale_from language: language
        end
      end

      module_function

      # Returns the language and region parts of the given locale.
      # For example:
      #
      # Given locale: "en-US"
      # #=> [:en, :us]
      #
      # Given locale: "en"
      # #=> [:en, nil]
      def split_locale(locale)
        language, region = locale.split('-')
        [language_from(language)].tap do |locale_array|
          locale_array << region_from(region) if region
        end
      end

      # Returns the locale, given a language and region.
      # For example:
      #
      # Given language: :en, region: :us
      # #=> "en-US"
      #
      # Given language: :en, region: nil
      # #=> "en"
      def locale_from(language:, region: nil)
        language = language_from language
        region = region_from region

        return "#{language}-#{region}" if language && region
        return language if language

        raise LittleWeasel::Errors::LanguageRequiredError
      end

      # Returns the language, given a language.
      # For example:
      #
      # Given language: :en
      # #=> "en"
      def language_from(language)
        language.to_s.downcase if language.present?
      end

      # Returns the region, given a region.
      # For example:
      #
      # Given region: :us
      # #=> "US"
      def region_from(region)
        region.to_s.upcase if region.present?
      end
    end
  end
end
