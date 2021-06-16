# frozen_string_literal: true

require_relative 'word_preprocessors_validatable'

module LittleWeasel
  module Preprocessors
    # This module provides the word_preprocessors attribute for objects
    # that support word preprocessors.
    module WordPreprocessable
      @word_preprocessors = []

      attr_reader :word_preprocessors

      private

      attr_writer :word_preprocessors
    end
  end
end
