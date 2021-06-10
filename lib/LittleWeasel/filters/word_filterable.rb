# frozen_string_literal: true

require_relative '../errors/must_override_error'

module LittleWeasel
  module Filters
    # This module provides methods/functionality for filtering dictionary words.
    module WordFilterable
      attr_reader :position

      def word_valid?(word:)
        raise Errors::MustOverrideError
      end

      private

      attr_writer :position
    end
  end
end
