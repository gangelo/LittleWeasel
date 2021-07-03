# frozen_string_literal: true

require_relative 'word_filterable'
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
      include WordFilterable
      include WordFiltersValidatable

      # Override attr_reader word_filter found in WordFilterable
      # so that we don't raise nil errors when using word_filters.
      def word_filters
        @word_filters ||= []
      end

      def clear_filters
        self.word_filters = []
      end

      # Appends word filters to the #word_filters Array.
      #
      # If Argument word_filter is nil, a block must be passed to populate
      # the word_filters with an Array of valid word filter objects.
      #
      # This method is used for adding/appending word filters to the
      # word_filters Array. To replace word filters, use #replace_filters;
      # to perform any other manipulation of the word_filters Array,
      # use #word_filters directly.
      def add_filters(word_filters: nil)
        return if word_filters.is_a?(Array) && word_filters.blank?

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

      def filters_matched(word)
        raise ArgumentError, "Argument word is not a String: #{word.class}" unless word.is_a? String

        return [] if word_filters.blank?
        return [] if word.empty?

        word_filters.filter_map do |word_filter|
          word_filter.to_sym if word_filter.filter_match?(word)
        end
      end

      def filter_match?(word)
        filters_matched(word).present?
      end
    end
  end
end
