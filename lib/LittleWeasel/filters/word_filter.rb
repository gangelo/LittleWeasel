# frozen_string_literal: true

require_relative '../errors/must_override_error'

module LittleWeasel
  module Filters
    # This module provides methods/functionality for filtering dictionary words.
    class WordFilter
      attr_accessor :filter_on

      def initialize(filter_on: true)
        raise ArgumentError, "Argument filter_on is not true or false: #{filter_on}" unless [true,
                                                                                             false].include? filter_on

        self.filter_on = filter_on
      end

      class << self
        def filter_match?(_word)
          raise Errors::MustOverrideError
        end
      end

      def filter_match?(word)
        return false unless filter_on?

        self.class.filter_match? word
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
