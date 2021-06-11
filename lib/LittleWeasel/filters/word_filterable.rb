# frozen_string_literal: true

require_relative '../errors/must_override_error'

module LittleWeasel
  module Filters
    # This module provides methods/functionality for filtering dictionary words.
    module WordFilterable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def word_valid?(word)
          filter_match? word
        end

        # Override this method and return true if the filter matches.
        def filter_match?(word)
          raise Errors::MustOverrideError
        end
      end
    end
  end
end
