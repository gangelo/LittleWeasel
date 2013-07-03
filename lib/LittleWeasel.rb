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
      @options = {exclude_alphabet: false, strip_whitespace: false}
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
    #
    # @example
    #
    #  LittleWeasel::Checker.instance.exists?('C') # true (default options, :exclude_alphabet => false)
    #  LittleWeasel::Checker.instance.exists?('A', {exclude_alphabet:true}) # false
    #  LittleWeasel::Checker.instance.exists?('X', {exclude_alphabet:false}) # true
    #  LittleWeasel::Checker.instance.exists?('Hello') # true
    #  LittleWeasel::Checker.instance.exists?('Hello World') # false, two words does not a single word make :)
    #
    #  LittleWeasel::Checker.instance.exists?(' Hello ') # false (default options, :strip_whitespace => false)
    #  LittleWeasel::Checker.instance.exists?(' Yes ', {strip_whitespace:true}) # true
    #  LittleWeasel::Checker.instance.exists?('No ', {strip_whitespace:false}) # false
    #  LittleWeasel::Checker.instance.exists?('Hell o', {strip_whitespace:true}) # false, strip_whitespace only removes leading and trailing spaces
    #
    def exists?(word, options=nil)
      options = options || @options

      return false unless word.is_a?(String)

      word.strip! if options[:strip_whitespace]

      return false if word.empty?

      return false if options[:exclude_alphabet] && word.length == 1 && @alphabet_exclusion_list.include?(word.upcase)

      dictionary.has_key? word
    end

    # Sets the global options for this gem.
    #
    # @param [Hash] options options that should apply to all subsequent calls to method *exists?* (see #exists?).
    #  Options set via this property apply to all subsequent queries.
    # @option options [Boolean] :exclude_alphabet (false) If false, letters of the alphabet are considered words.
    #  For example, LittleWeasel::Checker.instance.exists?('A'), will return true.
    # @option options [Boolean] :strip_whitespace (false) If true, leading and trailing spaces are removed before checking to see if the word exists.
    #  For example, LittleWeasel::Checker.instance.exists?(' Hello ', {strip_whitespace:true}), will return true.
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
    #  LittleWeasel::Checker.instance.options({strip_whitespace:false})
    #  LittleWeasel::Checker.instance.exists?(' Hello ') # false
    #  LittleWeasel::Checker.instance.exists?('No ') # false
    #  LittleWeasel::Checker.instance.exists?(' No') # false
    #
    #  LittleWeasel::Checker.instance.options({strip_whitespace:true})
    #  LittleWeasel::Checker.instance.exists?(' Yes ') # true
    #  LittleWeasel::Checker.instance.exists?('Hell o') # false, strip_whitespace only removes leading and trailing spaces
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