# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'preprocessors/preprocessed_word_results_validatable'

module LittleWeasel
  # This class represents the results of attempting to find a word
  # in a dictionary.
  class WordResults
    include Preprocessors::PreprocessedWordResultsValidatable

    attr_reader :filters_matched, :original_word, :preprocessed_word_results, :word_cached, :word_valid

    delegate :preprocessed_word, to: :preprocessed_word_results

    def initialize(original_word:, filters_matched: [],
      preprocessed_word_results: nil, word_cached: false, word_valid: false)
      self.original_word = original_word
      self.filters_matched = filters_matched
      self.word_cached = word_cached
      self.word_valid = word_valid

      validate

      if preprocessed_word_results.present?
        validate_prepreprocessed_word_results preprocessed_word_results: preprocessed_word_results
      end
      self.preprocessed_word_results = preprocessed_word_results
    end

    def validate
      raise ArgumentError, "Argument original_word is not a String: #{original_word.class}" \
        unless original_word.is_a? String
      raise ArgumentError, "Argument filters_matched is not an Array: #{filters_matched.class}" \
        unless filters_matched.is_a? Array
      raise ArgumentError, "Argument word_cached is not true or false: #{word_cached.class}" \
        unless [true, false].include? word_cached
      raise ArgumentError, "Argument word_valid is not true or false: #{word_cached.class}" \
        unless [true, false].include? word_valid
    end

    # Returns true if the word is valid (found in the dictionary), or
    # the word was matched against at least one filter; false, otherwise.
    def success?
      filter_match? || word_valid?
    end

    # Returns true if the word was matched against at least one filter;
    # false, otherwise.
    def filter_match?
      filters_matched.present?
    end

    # Returns true if the word was passed through any preprocessing. If
    # this is the case, #preprocessed_word may be different than
    # #original_word. Preprocessing should take place before any filtering
    # takes place. #word_cached, #word_valid and #filters_matched should
    # reflect that of the #preprocessed_word if #preprocessed_word is
    # present?
    def preprocessed_word?
      preprocessed_word.present?
    end

    # Returns true if the word was found in the dictionary as a valid word
    # or, the word was found in the cache as an invalid word.
    def word_cached?
      word_cached
    end

    # Returns true if the word was found in the dictionary; false, otherwise.
    def word_valid?
      word_valid
    end

    private

    attr_writer :filters_matched, :original_word, :preprocessed_word_results, :word_cached, :word_valid
  end
end
