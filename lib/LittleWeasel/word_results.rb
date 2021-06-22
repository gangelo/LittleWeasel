# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'preprocessors/preprocessed_words_validatable'

module LittleWeasel
  # This class represents the results of attempting to find a word
  # in a dictionary.
  class WordResults
    include Preprocessors::PreprocessedWordsValidatable

    attr_reader :filters_matched, :original_word, :preprocessed_words, :word_cached, :word_valid

    delegate :preprocessed_word, to: :preprocessed_words, allow_nil: true

    # Important: Regarding Boolean Methods
    #
    # The return value of some of the boolean methods (i.e. methods ending with
    # a '?') of this class depend on whether or not #original_word
    # has passed through any preprocessing. If #orginal_word has passed
    # through preprocessing, the following boolean methods will reflect
    # that of #preprocessed_word; if #original_word has NOT passed through
    # any preprocessing, the following methods will reflect that of
    # #original_word:
    #
    # #success?
    # #filter_match?
    # #word_cached?
    # #word_valid?
    #
    # In other words, if #original_word has passed through preprocessing
    # and has been altered by any of the preprocessing modules, it is the
    # #preprocessed_word that is passed through any subsequent word filters,
    # checked against the dictionary for validity, and cached, NOT
    # #original_word.
    def initialize(original_word:, filters_matched: [],
      preprocessed_words: nil, word_cached: false, word_valid: false)

      self.original_word = original_word
      self.filters_matched = filters_matched
      self.word_cached = word_cached
      self.word_valid = word_valid
      self.preprocessed_words = preprocessed_words
    end

    def original_word=(value)
      validate_original_word(original_word: value)
      @original_word = value
    end

    def filters_matched=(value)
      validate_filters_matched(filters_matched: value)
      @filters_matched = value
    end

    def word_cached=(value)
      validate_word_cached(word_cached: value)
      @word_cached = value
    end

    def word_valid=(value)
      vaidate_word_valid(word_valid: value)
      @word_valid = value
    end

    def preprocessed_words=(value)
      if value.present?
        validate_prepreprocessed_words preprocessed_words: value
        @preprocessed_words = value
      end
    end

    # Returns true if the word is valid (found in the dictionary), or
    # the word was matched against at least one filter; false, otherwise.
    #
    # Use the results of this method if you want to consider a word's
    # validity as having been found in the dictionary as a valid word OR
    # if the word has at least one word filter match. If the word has
    # NOT passed through any word filters, or if word DID NOT match any
    # filters, yet, it was found as a valid word in the dictionary, this
    # method will return true and vice versa.
    #
    # See "Important: Regarding Boolean Methods" notes at the top of this
    # class definition for more detail.
    def success?
      filter_match? || word_valid?
    end

    # Returns true if the word was found in the dictionary; false, otherwise.
    #
    # Use the results of this method if you want to consider a word's
    # validity irrespective of whether or not the word has matched any word
    # filters (if any).
    #
    # See "Important: Regarding Boolean Methods" notes at the top of this
    # class definition for more detail.
    def word_valid?
      word_valid
    end

    # Returns true if the word was matched against at least one filter;
    # false, otherwise.
    #
    # See "Important: Regarding Boolean Methods" notes at the top of this
    # class definition for more detail.
    def filter_match?
      filters_matched.present?
    end

    # Returns true if #original_word passed through any preprocessing. If
    # this is the case, #preprocessed_word may be different than
    # #original_word. Preprocessing should take place before any filtering
    # takes place.
    #
    # #word_cached, #word_valid and #filters_matched should all
    # reflect that of the #preprocessed_word if #preprocessed_word is
    # present?; otherwise, they should all reflect that of #original_word.
    def preprocessed_word?
      preprocessed_word.present?
    end

    # Returns #preprocessed_word (if available) or #original_word.
    # #preprocessed_word will be present if #original_word has
    # met the criteria for preprocessing and passed through at least
    # one preprocessor.
    #
    # See "Important: Regarding Boolean Methods" notes at the top of this
    # class definition for more detail.
    def preprocessed_word_or_original_word
      preprocessed_word || original_word
    end

    # Returns true if the word was found in the dictionary as a valid word
    # OR if the word was found in the cache as an invalid word.
    #
    # See "Important: Regarding Boolean Methods" notes at the top of this
    # class definition for more detail.
    def word_cached?
      word_cached
    end

    private

    def validate_original_word(original_word:)
      raise ArgumentError, "Argument original_word is not a String: #{original_word.class}" \
        unless original_word.is_a? String
    end

    def validate_filters_matched(filters_matched:)
      raise ArgumentError, "Argument filters_matched is not an Array: #{filters_matched.class}" \
        unless filters_matched.is_a? Array
    end

    def validate_word_cached(word_cached:)
      raise ArgumentError, "Argument word_cached is not true or false: #{word_cached.class}" \
        unless [true, false].include? word_cached
    end

    def vaidate_word_valid(word_valid:)
      raise ArgumentError, "Argument word_valid is not true or false: #{word_cached.class}" \
        unless [true, false].include? word_valid
    end
  end
end
