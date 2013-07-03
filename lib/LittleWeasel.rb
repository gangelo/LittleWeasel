require 'singleton'
require "LittleWeasel/version"

module LittleWeasel

  # Provides methods to interrogate the dictionary.
  class Checker
    include Singleton

    # Returns the dictionary.
    #
    # @return [Hash] the dictionary.
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
    # @param [Hash] options options to apply to this query (see #options=).  Options passed to this
    #   method are applied for this query only.
    #
    # @return [Boolean] true if *word* exists, false otherwise.
    def exists?(word, options=nil)
      options = options || @options

      return false if word.nil? || !word.is_a?(String)
      return false if options[:exclude_alphabet] && word.length == 1 && @alphabet_exclusion_list.include?(word.upcase)

      dictionary.has_key? word
    end

    # Sets the global options for this gem.
    #
    # @param [Hash] options options that should apply to all subsequent calls to method *exists?* (see #exists?).
    #  Options set via this property apply to all subsequent queries.
    # @option options [Boolean] :exclude_alphabet (false) If false, letters of the alphabet are considered words.
    #  For example, LittleWeasel::Checker.instance.exists?('A'), will return true.
    #
    # @return [Hash] The options
    #
    # @example
    #  LittleWeasel::Checker.instance.options({exclude_alphabet:true})
    #  LittleWeasel::Checker.instance.exists?('A') # false
    #
    #  LittleWeasel::Checker.instance.options({exclude_alphabet:false})
    #  LittleWeasel::Checker.instance.exists?('A') # true
    #
    def options=(options)
      @options = options
    end

    # Gets the global options currently set for this gem.
    #
    # @return [Hash] The options
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