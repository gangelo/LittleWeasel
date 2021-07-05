# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module LittleWeasel
  module Modules
    # Provides methods for normalizing a region for a locale.
    module Region
      def region?
        region.present?
      end

      def normalize_region!
        self.region = normalize_region region
      end

      module_function

      def normalize_region(region)
        region&.upcase
      end
    end
  end
end
