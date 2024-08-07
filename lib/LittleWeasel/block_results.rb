# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'word_results'

module LittleWeasel
  # This class represents the results of gathering information about a word
  # block (group of words).
  class BlockResults
    # :reek:Attribute - Ignored, it doesn't make sense to create a formal setter method.
    attr_reader :original_word_block, :word_results

    def initialize(original_word_block:)
      self.original_word_block = original_word_block
      self.word_results = []
    end

    def <<(word_result)
      unless word_result.is_a? WordResults
        raise ArgumentError, "Argument word_result is not a WordResults object: #{word_result.class}"
      end

      word_results << word_result
    end

    # Calls #success? on all WordResults objects. Returns true if all
    # WordResults return true; false is returned otherwise.
    def success?
      return false unless word_results.present?

      word_results.all?(&:success?)
    end

    # Returns true if all WordResults object words are valid (#word_valid?);
    # false otherwise.
    def words_valid?
      return false unless word_results.present?

      word_results.all?(&:word_valid?)
    end

    # Returns true if all WordResults object words have filter matches (#filters_match?);
    # false otherwise.
    def filters_match?
      return false unless word_results.present?

      word_results.all?(&:filter_match?)
    end

    # Returns true if all WordResults object words have been preprocessed (#preprocessed_words?);
    # false otherwise.
    def preprocessed_words?
      return false unless word_results.present?

      word_results.all?(&:preprocessed_word?)
    end

    # Returns an Array of the results of calling
    # #preprocessed_word_or_original_word on all WordResults objects.

    # Calls #preprocessed_word_or_original_word on all WordResults objects.
    # An Array of the results is returned.
    def preprocessed_words_or_original_words
      return [] unless word_results.present?

      word_results.map(&:preprocessed_word_or_original_word)
    end

    # Returns true if all WordResults object words have been cached (#words_cached?);
    # false otherwise.
    def words_cached?
      return false unless word_results.present?

      word_results.all?(&:word_cached?)
    end

    private

    attr_writer :original_word_block, :word_results
  end
end
