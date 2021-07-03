# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a value that can be used
    # in sorting.
    module OrderValidatable
      def self.validate(order:)
        raise ArgumentError, "Argument order is not an Integer: #{order.class}" unless order.is_a? Integer
        raise ArgumentError, "Argument order '#{order}' is not a a number from 0-n" if order.negative?
      end

      def validate_order(order:)
        OrderValidatable.validate order: order
      end
    end
  end
end
