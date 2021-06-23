# frozen_string_literal: true

require_relative 'tag_validatable'

module LittleWeasel
  module Modules
    # This module provides methods to manage objects that can be tagged.
    # A tag is a value that can be included as part of a DictionaryKey
    # object to make it unique across locales.
    #
    # @examples
    #
    #   en-US-<tag>
    #
    #   Where <tag> = a String to make this locale unique across locales
    #   of the same language and region.
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
