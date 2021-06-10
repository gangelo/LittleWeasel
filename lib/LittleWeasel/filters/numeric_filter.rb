# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative 'word_filterable'

module LittleWeasel
  module Filters
    # This class represents a numeric filter.
    class NumericFilter
      include WordFilterable

      REGEX = /^[-+]?[[:digit:]]*?(\.[[:digit:]]+)?$+/
      POSITION_REGEX = /^[[:digit:]]+$/

      def initialize(position)
        raise ArgumentError, "Argument position is not a valid position: #{position}" unless position.to_s =~ POSITION_REGEX

        self.position = position
      end

      def word_valid?(word)
        REGEX.match? word.to_s
      end
    end
  end
end
