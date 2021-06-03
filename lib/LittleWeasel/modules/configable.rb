# frozen_string_literal: true

module LittleWeasel
  module Modules
    module Configable
      def self.included(base)
        base.extend(ConfigableClassMethods)
      end

      module ConfigableClassMethods
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
