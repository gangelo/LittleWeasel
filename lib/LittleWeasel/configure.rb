# frozen_string_literal: true

# This is the configuration for LittleWeasel.
module LittleWeasel
  class << self
    attr_reader :configuration

    # Returns the application configuration object.
    #
    # @return [Configuration] the application Configuration object.
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    private

    attr_writer :configuration
  end

  # This class holds the configuration properties for this gem.
  class Configuration
    attr_reader :max_dictionary_file_megabytes,
      :max_invalid_words_bytesize, :metadata_observers, :word_filters,
      :word_preprocessors

    def initialize
      reset
    end

    def reset
      @max_dictionary_file_megabytes = 5
      @max_invalid_words_bytesize = 25_000
      @metadata_observers = [
        LittleWeasel::Metadata::InvalidWordsMetadata
      ]
      @word_filters = [
        LittleWeasel::Filters::NumericFilter,
        LittleWeasel::Filters::SingleCharacterWordFilter
      ]
      @word_preprocessors = []
    end

    def max_dictionary_file_bytes
      @max_dictionary_file_megabytes * 1_000_000
    end

    def max_invalid_words_bytesize?
      max_invalid_words_bytesize.positive?
    end

    # rubocop: disable Style/TrivialAccessors
    def max_dictionary_file_megabytes=(value)
      @max_dictionary_file_megabytes = value
    end

    def max_invalid_words_bytesize=(value)
      value = 0 if value.negative?
      @max_invalid_words_bytesize = value
    end

    def metadata_observers=(value)
      raise ArgumentError, "Argument value is not an Array: #{value.class}" unless value.is_a? Array

      # TODO: Limit the amount of observer classes, exploits?

      @metadata_observers = value
    end

    def word_filters=(value)
      raise ArgumentError, "Argument value is not an Array: #{value.class}" unless value.is_a? Array

      # TODO: Limit the amount of word filter classes, exploits?

      @word_filters = value
    end

    def word_preprocessors=(value)
      raise ArgumentError, "Argument value is not an Array: #{value.class}" unless value.is_a? Array

      # TODO: Limit the amount of word preprocessor classes, exploits?

      @word_preprocessors = value
    end
    # rubocop: enable Style/TrivialAccessors
  end
end
