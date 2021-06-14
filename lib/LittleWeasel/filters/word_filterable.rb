# frozen_string_literal: true

require_relative 'word_filters_validatable'

module LittleWeasel
  module Filters
    # This module provides the word_filters attribute for objects
    # that support word filters.
    module WordFilterable
      @word_filters = []

      attr_reader :word_filters

      private

      attr_writer :word_filters
    end
  end
end
