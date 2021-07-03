# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative '../modules/class_name_to_symbol'

module LittleWeasel
  module Filters
    # This module provides methods/functionality for filtering dictionary words.
    class WordFilter
      include Modules::ClassNameToSymbol

      attr_reader :filter_on

      def initialize
        filter_on!
      end

      class << self
        # Should return true if this word matches the filter criteria; false,
        # otherwise. This class method is unlike the instance method in that it
        # does not consider whether or not this filter is "on" or "off"; it
        # simply returns true or false based on whether or not the word matches
        # the filter.
        def filter_match?(_word)
          raise Errors::MustOverrideError
        end
      end

      def filter_on=(value)
        raise ArgumentError, "Argument value is not true or false: #{value.class}" \
          unless [true, false].include? value

        @filter_on = value
      end

      def filter_match?(word)
        return false if filter_off?

        self.class.filter_match? word
      end

      def filter_on!
        self.filter_on = true
      end

      def filter_off!
        self.filter_on = false
      end

      def filter_on?
        filter_on
      end

      def filter_off?
        !filter_on?
      end
    end
  end
end
