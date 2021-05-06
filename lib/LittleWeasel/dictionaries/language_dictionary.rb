# frozen_string_literal: true

module LittleWeasel
  module Dictionaries
    # This class describes a language dictionary type. A
    # "language" dictionary is the dictionary that is
    # used for a particular languace (e.g. language :en)
    # irrespective of any region (e.g. region: :us).
    # This is the default dictionary that should be used
    # as the fallback dictionary if a dictionary does
    # not exist for a particular locale (language and region).
    # In other words, if a dictionary associated with
    # language: en: and region: :us does not exist, but
    # a language dictionary exists for language: :en,
    # the language dictionary for language: :en should
    # be used.
    class LanguageDictionary < Dictionary
      attr_reader :language

      def initialize(language:, file:, tag: nil)
        self.language = language
        super(file: file, tag: tag)
      end

      protected

      def validate_arguments
        super
        raise 'Argument language nil or not a Symbol (e.g. :en, :es, etc.)' unless language.is_a? Symbol
      end

      private

      attr_writer :language
    end
  end
end
