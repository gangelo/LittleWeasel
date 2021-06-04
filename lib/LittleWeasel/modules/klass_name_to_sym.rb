# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to convert the class name of the class
    # mixing this module in to snake-case.
    module KlassNameToSym
      def self.included(base)
        base.extend(ClassMethods)
      end

      # class method inclusions for convenience.
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
