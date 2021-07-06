# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a tag.
    module TagValidatable
      module_function

      def validate_tag(tag:)
        raise ArgumentError, "Argument tag '#{tag}' is not a Symbol." unless tag.blank? || tag.is_a?(Symbol)
      end
    end
  end
end
