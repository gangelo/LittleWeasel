# frozen_string_literal: true

module LittleWeasel
  module Modules
    module KlassNameToSym
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def to_sym
          name.demodulize.underscore.to_sym
        end
      end

      def to_sym
        self.class.to_sym
      end
    end
  end
end
