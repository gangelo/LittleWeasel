# frozen_string_literal: true

module LittleWeasel
  module Filters
    # This module provides methods/functionality to manage word filters.
    module WordFilterManagable
      attr_reader :word_filters

      def filter_match?(word)
        return false if word_filter.nil? || word_filter.empty?

        word_filters.any? do |word_filter|
          word_filter.filter_match? word
        end
      end

      private

      attr_writer :word_filters
    end
  end
end
