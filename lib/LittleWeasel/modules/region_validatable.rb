# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a region.
    module RegionValidatable
      def self.validate(region:)
        raise ArgumentError, "Argument region '#{region}' is not a Symbol." unless region.blank? || region.is_a?(Symbol)
      end

      def validate_region(region:)
        RegionValidatable.validate region: region
      end
    end
  end
end
