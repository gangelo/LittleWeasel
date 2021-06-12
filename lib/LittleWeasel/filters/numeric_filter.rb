# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative 'word_filter'

module LittleWeasel
  module Filters
    # This class represents a numeric filter.
    class NumericFilter < WordFilter
      class << self
        def filter_match?(word)
          /^[-+]?[[:digit:]]*?(\.[[:digit:]]+)?$+/.match? word.to_s
        end
      end
    end
  end
end

