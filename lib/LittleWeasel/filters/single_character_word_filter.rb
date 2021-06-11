# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative 'word_filterable'

module LittleWeasel
  module Filters
    # This class represents a filter for single character words.
    class SingleCharacterWordFilter
      include WordFilterable

      class << self
        private

        def filter_match?(word)
          return false unless word.is_a? String

          /[aAI]/.match? word.to_s
        end
      end
    end
  end
end
