# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a word results
    module WordResultsValidatable
      def validate_original_word
        raise ArgumentError, "Argument original_word is not a String: #{original_word.class}" \
          unless original_word.is_a? String
      end

      def validate_filters_matched
        raise ArgumentError, "Argument filters_matched is not an Array: #{filters_matched.class}" \
          unless filters_matched.is_a? Array
      end

      def validate_word_cached
        raise ArgumentError, "Argument word_cached is not true or false: #{word_cached.class}" \
          unless [true, false].include? word_cached
      end

      def vaidate_word_valid
        raise ArgumentError, "Argument word_valid is not true or false: #{word_cached.class}" \
          unless [true, false].include? word_valid
      end
    end
  end
end
