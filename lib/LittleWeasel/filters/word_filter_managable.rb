# frozen_string_literal: true

require_relative 'word_filter_validatable'

module LittleWeasel
  module Filters
    # This module provides methods/functionality to manage word filters.
    # Word fliters are processes through which words are passed; if the
    # process returns true, the word should be considered valid and all
    # subsequent filters ignored; if the process returns false, the word
    # should be passed to the next filter, and so on. Word filters should
    # typically be checked BEFORE checking a word against a dictionary.
    module WordFilterManagable
      include WordFilterValidatable

      def word_filters
        @word_filters ||= []
      end

      # Adds word filters to the #word_filters Array.
      def add_filters(word_filters: nil)
        self.word_filters = []

        word_filters ||= config.word_filters
        yield word_filters if block_given?

        word_filters.each do |word_filter|
          word_filter_object = word_filter.new
          validate_word_filter word_filter: word_filter_object

          self.word_filters << word_filter_object
        end

        self.word_filters
      end

      def filter_match?(word)
        raise ArgumentError, "Argument word is not a String: #{word.class}" unless word.is_a? String

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
