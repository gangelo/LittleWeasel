# frozen_string_literal: true

module LittleWeasel
  module Modules
    module Configurable
      def self.included(base)
        base.extend(ClassMethods)
      end

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
