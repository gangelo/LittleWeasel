# frozen_string_literal: true

require_relative '../../errors/must_override_error'
require_relative '../word_filter'

module LittleWeasel
  module Filters
    module EnUs
      # This class represents a filter for single character words.
      class SingleCharacterWordFilter < WordFilter
        class << self
          def filter_match?(word)
            return false unless word.is_a? String

            /^[aAI]{1}$/.match? word.to_s
          end
        end
      end
    end
  end
end
