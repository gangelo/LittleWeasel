# frozen_string_literal: true

require_relative 'word_filter_validatable'

module LittleWeasel
  module Filters
    # This module provides methods to validate an Array of word filters.
    module WordFiltersValidatable
      extend WordFilterValidatable

      def self.validate(word_filters:)
        raise ArgumentError, 'Argument word_filters is blank' if word_filters.blank?

        unless word_filters.is_a? Array
          raise ArgumentError,
            "Argument word_filters is not an Array: #{word_filters.class}"
        end

        word_filters.each do |word_filter|
          validate_word_filter word_filter: word_filter
        end
      end

      def validate_word_filters(word_filters:)
        WordFiltersValidatable.validate word_filters: word_filters
      end
    end
  end
end
