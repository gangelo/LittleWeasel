# frozen_string_literal: true

require_relative 'modules/locale'

module LittleWeasel
  # This class describes a unique key associated with a particular dictionary
  # file. Dictionary keys are used to identify a dictionary on which an action
  # should be performed.
  class DictionaryKey
    include Modules::Locale

    attr_reader :language, :region, :tag

    def initialize(language:, region: nil, tag: nil)
      raise ArgumentError, 'Argument language is not a Symbol' unless language.is_a? Symbol
      raise ArgumentError, 'Argument region is not a Symbol' if region.present? && !region.is_a?(Symbol)

      self.language = self.class.normalize_language language
      self.region = self.class.normalize_region region
      self.tag = tag
    end

    def key
      return locale unless tag.present?

      "#{locale}-#{tag}"
    end
    alias to_s key

    class << self
      def key(language:, region: nil, tag: nil)
        new(language: language, region: region, tag: tag).key
      end
    end

    private

    attr_writer :language, :region, :tag
  end
end
