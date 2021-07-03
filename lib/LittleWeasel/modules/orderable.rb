# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides attribtues and methods to manage objects that can be
    # ordered or sorted.
    module Orderable
      include OrderValidatable

      attr_reader :order

      private

      attr_writer :order
    end
  end
end
