# frozen_string_literal: true

require_relative 'modules/language_validatable'
require_relative 'modules/locale'
require_relative 'modules/region_validatable'
require_relative 'modules/taggable'

module LittleWeasel
  # This class describes a unique key associated with a particular dictionary
  # file. Dictionary keys are used to identify a dictionary on which an action
  # should be performed.
  class DictionaryKey
    include Modules::LanguageValidatable
    include Modules::Locale
    include Modules::RegionValidatable
    include Modules::Taggable

    attr_reader :language, :region

    def initialize(language:, region: nil, tag: nil)
      validate_language language: language
      self.language = normalize_language language

      validate_region region: region
      self.region = normalize_region region

      validate_tag tag: tag
      self.tag = tag
    end

    def key
      return locale unless tagged?

      "#{locale}-#{tag}"
    end
    alias to_s key

    class << self
      def key(language:, region: nil, tag: nil)
        new(language: language, region: region, tag: tag).key
      end
    end

    private

    attr_writer :language, :region
  end
end
