# frozen_string_literal: true

require_relative '../errors/must_override_error'

module LittleWeasel
  module Filters
    # This module provides methods/functionality for filtering dictionary words.
    module WordFilterable
      attr_reader :position

      def word_valid?(word:, word_filters:)
        raise Errors::MustOverrideError
      end

      def continue?
        raise Errors::MustOverrideError
      end

      def next_filter?
      end

      private

      attr_writer :position
    end
  end
end
