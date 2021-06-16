# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides attribtues/methods to handle objects that can be
    # ordered or sorted.
    module Orderable
      include OrderValidatable

      attr_reader :order

      private

      attr_writer :order
    end
  end
end
