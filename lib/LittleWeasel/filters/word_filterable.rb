# frozen_string_literal: true

require_relative 'word_filters_validatable'

module LittleWeasel
  module Filters
    # This module provides the word_filters attribute for objects
    # that support word filters.
    module WordFilterable
      def word_filters
        @word_filters ||= []
      end

      private

      attr_writer :word_filters
    end
  end
end
