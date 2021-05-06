# frozen_string_literal: true

module LittleWeasel
  module Dictionaries
    # This class describes a region dictionary type.
    # A region dictionary is the dictionary that is
    # used for a particular region (e.g. locale: language :en,
    # region: :us); it is specific to that language and
    # region. This is the dictionary that should be used
    # if it is to be associated with a particular locale
    # (language and region.
    class RegionDictionary < LanguageDictionary
      attr_reader :region

      def initialize(language:, region:, file:, tag: nil)
        self.region = region
        super(language: language, file: file, tag: tag)
      end

      protected

      def validate_arguments
        super
        raise 'Argument region is nil or not a Symbol (e.g. :us, :gb, etc.)' unless region.is_a? Symbol
      end

      private

      attr_writer :region
    end
  end
end
