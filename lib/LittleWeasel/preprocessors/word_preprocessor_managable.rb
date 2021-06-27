# frozen_string_literal: true

require_relative 'word_preprocessable'
require_relative 'word_preprocessor_validatable'

module LittleWeasel
  module Preprocessors
    # This module provides methods and functionality to manage word
    # preprocessors. A "word preprocessor" is an object that manipulates a word
    # before it is passed to any word filters and before it is compared against
    # the dictionary for validity.
    #
    # When creating your own word preprocessors, here are some things you
    # need to consider:
    #
    # Multiple word preprocessors can be applied to a given word. Word
    # processors will be applied to a word in
    # Preprocessors::WordPreprocessor#order order (ascending). Even though this
    # is the case, it doesn't mean you should seek to apply more than one word
    # preprocessor at a time. However, if you do, write and order your word
    # preprocessors in such a way that each preprocessor manipulates the word
    # in a complimentary rather than contridictionary way. For example,
    # applying one word preprocessor that convert a word to uppercase and a
    # second that converts the word to lowercase, contradict each other.
    #
    # Another thing you need to consider, is whether or not metadata observers
    # should be notified of the preprocessed word (now that it has been
    # potentially manipulated) or if they should be notified of the original
    # word; this is because, the original word may not be found as a valid word
    # in the dictionary, while the preprocessed word might and vise versa.
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

        unless word_preprocessors.present? || block_given?
          raise 'A block is required if argument word_preprocessors is nil'
        end

        word_preprocessors ||= []
        yield word_preprocessors if block_given?

        concat_and_sort_word_preprocessors! word_preprocessors
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

      # Returns a Preprocessors::PreprocessedWords object.
      def preprocess(word:)
        preprocessed_words = preprocessed_words word: word
        PreprocessedWords.new(original_word: word, preprocessed_words: preprocessed_words)
      end

      def preprocessed_words(word:)
        word_preprocessors.map do |word_preprocessor|
          word_preprocessor.preprocess(word).tap do |processed_word|
            word = processed_word.preprocessed_word
          end
        end
      end

      # Returns the final (or last) preprocessed word in the Array of
      # preprocessed words. The final preprocessed word is the word that has
      # passed through all the word preprocessors.
      def preprocessed_word(word:)
        preprocessed_words = self.preprocessed_words word: word
        preprocessed_words.max_by(&:preprocessor_order).preprocessed_word unless preprocessed_words.blank?
      end

      private

      # This method concatinates preprocessors to #word_preprocessors,
      # sorts #word_preprocessors by WordPreprocessor#order and
      # returns the results.
      def concat_and_sort_word_preprocessors!(preprocessors)
        validate_word_preprocessors word_preprocessors: preprocessors

        word_preprocessors.concat preprocessors
        word_preprocessors.sort_by!(&:order)
      end
    end
  end
end
