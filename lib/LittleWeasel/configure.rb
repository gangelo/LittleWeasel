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

  # This class encapsulates the configuration properties for this gem and
  # provides methods and attributes that allow for management of the same.
  #
  # attr_reader :max_dictionary_file_megabytes, :max_invalid_words_bytesize, :metadata_observers
  class Configuration
    attr_reader :max_dictionary_file_megabytes,
      :max_invalid_words_bytesize, :metadata_observers, :word_block_regex

    # The constructor; calls {#reset}.
    def initialize
      reset
    end

    # Resets the configuration settings to their default values.
    #
    # @return [void]
    def reset
      @max_dictionary_file_megabytes = 5
      @max_invalid_words_bytesize = 25_000
      @metadata_observers = [
        LittleWeasel::Metadata::InvalidWordsMetadata
      ]
      # TODO: Is this the correct regex to use, or is there something better?
      # @word_block_regex = /\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/
      # @word_block_regex = /(?:(?:[\-A-Za-z0-9]|\d(?!\d|\b))+(?:'[\-A-Za-z0-9]+)?)/
      # @word_block_regex = /(?:(?:[\-a-z0-9]|\d(?!\d|\b))+(?:'[\-a-z0-9]+)?)/i
      @word_block_regex = /[[[:word:]]'-]+/
    end

    # Returns the maximum consumable dictionary size in bytes. Dictionaries
    # larger than {#max_dictionary_file_bytes} will raise an error.
    #
    # The default is 5 megabytes.
    #
    # @return [Integer] the maximum number of bytes for a dictionary.
    def max_dictionary_file_bytes
      @max_dictionary_file_megabytes * 1_000_000
    end

    # If {#max_invalid_words_bytesize} is > 0, true will be returned; false
    # otherwise.
    #
    # @return [true, false] based on {#max_invalid_words_bytesize}.
    def max_invalid_words_bytesize?
      max_invalid_words_bytesize.positive?
    end

    # rubocop: disable Style/TrivialAccessors
    def max_dictionary_file_megabytes=(value)
      @max_dictionary_file_megabytes = value
    end

    # Sets the maximum cache size (in bytes) for invalid words. If
    # less than or equal to 0, invalid words will NOT be cached.
    #
    # If greater than 0, invalid words will be cached up to and including
    # {#max_invalid_words_bytesize} bytes.
    #
    # @see #max_invalid_words_bytesize?
    def max_invalid_words_bytesize=(value)
      value = 0 if value.negative?
      @max_invalid_words_bytesize = value
    end

    def metadata_observers=(value)
      raise ArgumentError, "Argument value is not an Array: #{value.class}" unless value.is_a? Array

      # TODO: Limit the amount of observer classes, exploits?

      @metadata_observers = value
    end

    def word_block_regex=(value)
      @word_block_regex = value
    end
    # rubocop: enable Style/TrivialAccessors
  end
end
