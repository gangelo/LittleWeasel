# frozen_string_literal: true

module LittleWeasel
  module Filters
    # This module validates word filter types.
    module WordFilterValidatable
      def self.validate(word_filter:)
        raise ArgumentError, "Argument word_filter does not quack right: #{word_filter.class}" \
          unless valid_word_filter?(word_filter: word_filter)
      end

      # You can use your own word filter types as long as they quack correctly;
      # however, you are responsible for the behavior of these required methods/
      # attributes. It's probably better to follow the pattern of existing word
      # filter objects (e.g. Filters::NumericFilter) and inherit from
      # Filters::WordFilter.
      def self.valid_word_filter?(word_filter:)
        word_filter.respond_to?(:filter_on?) &&
          word_filter.respond_to?(:filter_off?) &&
          word_filter.respond_to?(:filter_on) &&
          word_filter.respond_to?(:filter_on=) &&
          word_filter.respond_to?(:filter_match?) &&
          word_filter.class.respond_to?(:filter_match?)
      end

      def validate_word_filter(word_filter:)
        WordFilterValidatable.validate word_filter: word_filter
      end
    end
  end
end
