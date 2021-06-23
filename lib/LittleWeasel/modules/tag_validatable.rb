# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to validate a tag.
    module TagValidatable
      def self.validate(tag:)
        raise ArgumentError, "Argument tag '#{tag}' is not a Symbol." unless tag.blank? || tag.is_a?(Symbol)
      end

      def validate_tag(tag:)
        TagValidatable.validate tag: tag
      end
    end
  end
end
