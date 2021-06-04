# frozen_string_literal: true

module LittleWeasel
  module Modules
    # This module provides methods to handle objects that can be tagged.
    module Taggable
      attr_reader :tag

      def tagged?
        tag.present?
      end

      def validate_tag
        "Argument tag (#{tag}) is not a Symbol" unless tagged? && tag.is_a?(Symbol)
      end

      private

      attr_writer :tag
    end
  end
end
