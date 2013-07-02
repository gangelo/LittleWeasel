require 'singleton'
require "LittleWeasel/version"

module LittleWeasel

  # Provides methods to interrogate the dictionary.
  class Checker
    include Singleton

    # Returns the dictionary.
    attr_reader :dictionary

    private

    attr_reader :alphanet_exclusion_list

    public

    # The constructor
    def initialize
      @options = {exclude_alphabet: false}
      @alphabet_exclusion_list = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z }
      @dictionary = Hash.new(1)
      load
    end

    # Interrogates the dictionary to determine whether or not [word] exists.
    #
    # @param [String] word the word to interrogate
    # @param [Hash] options options to apply to this query
    #
    # @return [Boolean] true if *word* exists, false otherwise.
    #
    # @note Valid *options* tag/value at this time are *\{exclude_alphabet: true|false\}*
    #
    def exists?(word, options=nil)
      options = options || @options

      return false if word.nil? || !word.is_a?(String)
      return false if options[:exclude_alphabet] && word.length == 1 && @alphabet_exclusion_list.include?(word.upcase)

      dictionary.has_key? word
    end

    # {exclude_alphabet: true} will return exist? == false for a-z, A-Z
    # {exclude_alphabet: false} will return exist? == true for a-z, A-Z
    def options=(options)
      @options = options
    end

    def options
      @options
    end

    private

    def dictionary_path
      File.expand_path(File.dirname(__FILE__) + '/dictionary')
    end

    def load
      File.open(dictionary_path) do |io|
        io.each { |line| line.chomp!; @dictionary[line] = line }
      end
    end
  end

end