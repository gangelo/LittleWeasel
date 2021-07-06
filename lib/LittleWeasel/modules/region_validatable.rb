# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a region.
    module RegionValidatable
      module_function

      def validate_region(region:)
        raise ArgumentError, "Argument region '#{region}' is not a Symbol." unless region.blank? || region.is_a?(Symbol)
      end
    end
  end
end
