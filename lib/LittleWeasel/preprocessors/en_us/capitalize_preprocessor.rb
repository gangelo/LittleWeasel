# frozen_string_literal: true

require_relative '../word_preprocessor'

module LittleWeasel
  module Preprocessors
    module EnUs
      # This preprocessor capitializes a word.
      class CapitalizePreprocessor < WordPreprocessor
        def initialize(order: 0, preprocessor_on: true)
          super
        end

        class << self
          def preprocess(word)
            [true, word.capitalize]
          end
        end
      end
    end
  end
end
