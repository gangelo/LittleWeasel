# frozen_string_literal: true

require_relative '../../errors/must_override_error'
require_relative '../word_filter'

module LittleWeasel
  module Filters
    module EnUs
      # This class represents a numeric filter.
      class NumericFilter < WordFilter
        class << self
          def filter_match?(word)
            /^[-+]?[[:digit:]]{1,3}(?:,?[[:digit:]]{3})*(?:\.[[:digit:]]{1,2})?$/.match? word.to_s
          end
        end
      end
    end
  end
end
