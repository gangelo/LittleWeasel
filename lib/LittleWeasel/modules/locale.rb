# frozen_string_literal: true

require_relative 'language'
require_relative 'region'

module LittleWeasel
  module Modules
    # This module provides methods to handle conversion of parts of a locale to
    # their string counter parts.
    module Locale
      include Language
      include Region

      def locale
        language = normalize_language self.language
        return language.to_s unless region?

        region = normalize_region self.region
        "#{language}-#{region}"
      end
    end
  end
end
