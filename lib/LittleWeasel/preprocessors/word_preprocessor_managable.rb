# frozen_string_literal: true

require_relative 'word_preprocessable'
require_relative 'word_preprocessor_validatable'

module LittleWeasel
  module Preprocessors
    # This module provides methods/functionality to manage word preprocessors.
    # Word preprocessors are processes through which words are passed before
    # determining whether or not they can be found in the dictionary. When
    # using word preprocessors, you need to consider whether or not metadata
    # observers should be notified of the preprocessed word now that it has
    # been preprocessed; because, the original word may not be found as a valid
    # word in the dictionary, while the preprocessed word might and vise
    # versa.
    module WordPreprocessorManagable
      include WordPreprocessable
      include WordPreprocessorsValidatable

      # Override attr_reader word_preprocessor found in WordPreprocessable
      # so that we don't raise nil errors when using word_preprocessors.
      def word_preprocessors
        @word_preprocessors ||= []
      end

      def clear_preprocessors
        self.word_preprocessors = []
      end

      # Appends word preprocessors to the #word_preprocessors Array.
      #
      # If Argument word_preprocessor is nil, a block must be passed to populate
      # the word_preprocessors with an Array of valid word preprocessor objects.
      #
      # This method is used for adding/appending word preprocessors to the
      # word_preprocessors Array. To replace word preprocessors, use #replace_preprocessors;
      # to perform any other manipulation of the word_preprocessors Array,
      # use #word_preprocessors directly.
      def add_preprocessors(word_preprocessors: nil)
        return if word_preprocessors.is_a?(Array) && word_preprocessors.blank?

        raise 'A block is required if argument word_preprocessors is nil' if word_preprocessors.nil? && !block_given?

        word_preprocessors ||= []
        yield word_preprocessors if block_given?

        validate_word_preprocessors word_preprocessors: word_preprocessors

        self.word_preprocessors.concat word_preprocessors

        self.word_preprocessors.sort_by(&:order)
      end
      alias append_preprocessors add_preprocessors

      def replace_preprocessors(word_preprocessors:)
        clear_preprocessors
        add_preprocessors word_preprocessors: word_preprocessors
      end

      def preprocessors_on=(on)
        raise ArgumentError, "Argument on is not true or false: #{on.class}" unless [true, false].include?(on)

        word_preprocessors.each { |word_preprocessor| word_preprocessor.preprocessor_on = on }
      end

      def preprocess(word)
        word_preprocessors.map do |word_preprocessor|
          word_preprocessor.preprocess word
        end
      end

      # def preprocessors_applied(word)
      #   raise ArgumentError, "Argument word is not a String: #{word.class}" unless word.is_a? String

      #   return [] if word_preprocessors.blank?
      #   return [] if word.empty?

      #   word_preprocessors.map do |word_preprocessor|
      #     word_preprocessor.to_sym if word_preprocessor.preprocessor_applied?(word)
      #   end.compact
      # end

      # def preprocessor_applied?(word)
      #   preprocessors_applied(word).present?
      # end
    end
  end
end
