# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative '../modules/class_name_to_symbol'
require_relative '../modules/orderable'
require_relative 'preprocessed_word'

module LittleWeasel
  module Preprocessors
    # This is a base class that provides methods and functionality for
    # word preprocessors. A "word preprocessor" is an object that manipulates a
    # word before it is passed to any word filters and before it is compared
    # against the dictionary for validity.
    class WordPreprocessor
      include Modules::ClassNameToSymbol
      include Modules::Orderable

      attr_reader :preprocessor_on

      # order:Integer, the order in which this preprocessor should
      # be applied.
      # preprocessor_on:Boolean, whether or not this preprocessor
      # should be applied to any words.
      def initialize(order:, preprocessor_on: true)
        validate_order order: order
        self.order = order
        self.preprocessor_on = preprocessor_on
      end

      class << self
        # Should return true if word matches the preprocess criteria;
        # false, otherwise. If this preprocessor has no preprocess criteria,
        # simply return true. This class method is unlike the instance method in
        # that it does not consider whether or not this preprocessor is "on"
        # or "off"; it simply returns true or false based on whether or not the
        # word matches the preprocess criteria.
        def preprocess?(_word)
          true
        end

        # This method should UNconditionally apply preprocessing to word ONLY if
        # word meets the criteria for preprocessing (.preprocess?).
        #
        # This method should return the following Array:
        #
        # [<preprocessed?>, <preprocessed word | nil>]
        #
        # Where:
        #
        #   <preprocessed?> == whether or not the word was preprocessed
        #     based on whether or not the word meets the preprocessing
        #     criteria (.preprocess?).
        #
        #   <preprocessed word | nil> == the preprocessed word (if word
        #     met the preprocessing criteria (.preprocessed?)) or nil if
        #     word was NOT preprocessed (word did NOT meet the preprocessing
        #     criteria).
        def preprocess(_word)
          raise Errors::MustOverrideError
        end
      end

      def preprocessor_on=(value)
        raise ArgumentError, "Argument value is not true or false: #{value}" \
          unless [true, false].include? value

        @preprocessor_on = value
      end

      # Returns true if word meets the criteria for preprocessing. false
      # is returned if word does not meet the criteria for preprocessing, or,
      # if the preprocessor is "off".
      def preprocess?(word)
        return false if preprocessor_off?

        self.class.preprocess? word
      end

      # Applies preprocessing to word if this preprocessor is "on" AND if word
      # meets the criteria for preprocessing; no preprocessing is applied to
      # word otherwise.
      #
      # This method should return a Preprocessors::PreprocessedWord object.
      def preprocess(word)
        preprocessed, preprocessed_word = if preprocessor_on?
          self.class.preprocess word
        else
          [false, nil]
        end
        preprocessed_word(original_word: word, preprocessed_word: preprocessed_word, preprocessed: preprocessed)
      end

      # Returns true if this preprocessor is "on"; false, otherwise. If this
      # preprocessor is "on", preprocessing should be applied to a word if word
      # meets the criteria for preprocessing.
      def preprocessor_on?
        preprocessor_on
      end

      # Returns true if this preprocessor is "off". Preprocessing should not
      # be applied to a word if this preprocessor is "off".
      def preprocessor_off?
        !preprocessor_on?
      end

      private

      def preprocessed_word(original_word:, preprocessed:, preprocessed_word:)
        PreprocessedWord.new(original_word: original_word, preprocessed: preprocessed,
          preprocessed_word: preprocessed_word, preprocessor: to_sym, preprocessor_order: order)
      end
    end
  end
end
