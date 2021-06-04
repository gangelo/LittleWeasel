# frozen_string_literal: true

module LittleWeasel
  module Modules
    # Provides methods for normalizing region for a locale,
    module Region
      def self.included(base)
        base.extend(ClassMethods)
      end

      # class method inclusions for convenience.
      module ClassMethods
        def normalize_region(region)
          region&.upcase
        end
      end

      def normalize_region
        self.class.normalize_region region
      end
    end
  end
end
