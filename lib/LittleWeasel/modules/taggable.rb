# frozen_string_literal: true

require_relative 'tag_validatable'

module LittleWeasel
  module Modules
    # This module provides methods to handle objects that can be tagged.
    module Taggable
      include TagValidatable

      attr_reader :tag

      def tagged?
        tag.present?
      end

      private

      attr_writer :tag
    end
  end
end
