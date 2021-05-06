# frozen_string_literal: true

# This is the configuration for LittleWeasel.
module LittleWeasel
  class << self
    attr_reader :configuration

    private

    attr_writer :configuration
  end

  # Returns the application configuration object.
  #
  # @return [Configuration] the application Configuration object.
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # This class holds the configuration properties for
  # this gem.
  class Configuration
    attr_reader :dictionaries, :ignore_numerics, :language, :region,
      :max_dictionary_file_megabytes, :max_invalid_words_bytesize, :numeric_regex,
      :single_character_words, :strip_whitespace, :word_regex

    def initialize
      @dictionaries = {}
      @ignore_numerics = true
      @language = nil
      @numeric_regex = /^[-+]?[0-9]?(\.[0-9]+)?$+/
      @max_dictionary_file_megabytes = 4
      @max_invalid_words_bytesize = 25_000
      @region = nil
      @single_character_words = /[aAI]/
      @strip_whitespace = true
      @word_regex = /\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/
    end

    def max_dictionary_file_bytes
      @max_dictionary_file_megabytes * 1_000_000
    end

    # rubocop: disable Style/TrivialAccessors
    # We may want to perform validation later on,
    # besides, reek flags these as writable attributes
    # if I simply made them attr_accessor/attr_writer
    def dictionaries=(value)
      @dictionaries = value
    end

    def ignore_numerics=(value)
      @ignore_numerics = value
    end

    def language=(value)
      @language = value
    end

    def numeric_regex=(value)
      @numeric_regex = value
    end

    def max_dictionary_file_megabytes=(value)
      @max_dictionary_file_megabytes = value
    end

    def max_invalid_words_bytesize=(value)
      @max_invalid_words_bytesize = value
    end

    def region=(value)
      @region = value
    end

    def single_character_words=(value)
      @single_character_words = value
    end

    def strip_whitespace=(value)
      @strip_whitespace = value
    end

    def word_regex=(value)
      @word_regex = value
    end
    # rubocop: enable Style/TrivialAccessors
  end
end
