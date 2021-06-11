# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative 'word_filterable'

module LittleWeasel
  module Filters
    # This class represents a numeric filter.
    class NumericFilter < WordFilterable
      class << self
        def filter_match?(word)
          /^[-+]?[[:digit:]]*?(\.[[:digit:]]+)?$+/.match? word.to_s
        end
      end
    end
  end
end
