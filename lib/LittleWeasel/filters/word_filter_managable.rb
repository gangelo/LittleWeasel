# frozen_string_literal: true

require_relative 'word_filters_validatable'

module LittleWeasel
  module Filters
    # This module provides methods/functionality to manage word filters.
    # Word fliters are processes through which words are passed; if the
    # process returns true, the word should be considered valid and all
    # subsequent filters ignored; if the process returns false, the word
    # should be passed to the next filter, and so on. When using word
    # filters, you need to consider whether or not metadata observers
    # should be notified of the word now that it is considered "valid"
    # although may not literally be a valid word in the dictionary.
    module WordFilterManagable
      include WordFiltersValidatable

      def word_filters
        @word_filters ||= []
      end

      def clear_filters
        self.word_filters = []
      end

      # Adds word filters to the #word_filters Array.
      #
      # If Argument word_filter is nil, a block must be passed to populate
      # the word_filters with an Array of valid word filter class types.
      def add_filters(word_filters: nil)
        raise 'A block is required if argument word_filters is nil' if word_filters.nil? && !block_given?

        word_filters ||= []
        yield word_filters if block_given?

        validate_word_filters word_filters: word_filters

        self.word_filters.concat word_filters
      end
      alias append_filters add_filters

      def replace_filters(word_filters:)
        clear_filters
        add_filters word_filters: word_filters
      end

      def filters_on=(on)
        raise ArgumentError, "Argument on is not true or false: #{on.class}" unless [true, false].include?(on)

        word_filters.each { |word_filter| word_filter.filter_on = on }
      end

      def filter_match?(word)
        raise ArgumentError, "Argument word is not a String: #{word.class}" unless word.is_a? String

        return false if word_filters.blank?

        word = word.strip
        return false if word.empty?

        word_filters.any? do |word_filter|
          word_filter.filter_match? word
        end
      end

      private

      attr_writer :word_filters
    end
  end
end
