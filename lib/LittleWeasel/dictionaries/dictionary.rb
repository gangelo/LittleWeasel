# frozen_string_literal: true

require_relative '../modules/dictionary_type'
require_relative '../modules/hash_keys'
require_relative '../modules/locale'
require_relative '../modules/taggable'

module LittleWeasel
  module Dictionaries
    # This class describes a base dictionary type.
    class Dictionary
      include Modules::HashKeys
      include Modules::DictionaryType
      include Modules::Locale
      include Modules::Taggable

      attr_reader :file

      def initialize(file:, tag: nil)
        self.file = file
        self.tag = tag
        validate_arguments
      end

      def to_hash
        { hash_key => file }
      end

      # This method returns the Hash key that will be used to
      # uniquely identify this dictionary in the session.
      #
      # @returns [String] having the format "language-[REGION]-[tag]"
      #
      # @examples
      #
      #  'en--'
      #  'en-US-''
      #  'en-US-slang'
      def hash_key
        @hash_key ||= join_key language: split_key[0], region: split_key[1], tag: tag
      end

      protected

      def split_key
        @split_key ||= split_locale locale
      end

      def validate_arguments
        raise 'Argument file is nil or not a String' unless file.is_a? String
        raise "Argument file (#{file}) does not exist" unless File.exist? file

        validate_tag
      end

      private

      attr_writer :file
    end
  end
end
