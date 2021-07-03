# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides convienience methods for accessing this gem's
    # configuration.
    module Configurable
      def self.included(base)
        base.extend(ClassMethods)
      end

      # class method inclusions for convenience.
      module ClassMethods
        def config
          LittleWeasel.configuration
        end
      end

      private

      def config
        @config ||= self.class.config
      end
    end
  end
end
