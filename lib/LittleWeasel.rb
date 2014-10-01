require 'singleton'
require "LittleWeasel/version"
require 'active_support/inflector'

module LittleWeasel

  # Provides methods to interrogate the dictionary.
  class Checker
    include Singleton

    # Returns the dictionary.
    #
    # @return [Hash] the dictionary.
    attr_reader :dictionary

    private

    attr_reader :alphabet_exclusion_list

    # Keep these private...will expose as options later.
    attr_accessor :word_regex, :numeric_regex, :non_wordchar_regex

    public

    # The constructor
    def initialize
      @options = { exclude_alphabet: false, strip_whitespace: false, ignore_numeric: true, single_word_mode: false }
      @alphabet_exclusion_list = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z }
      @numeric_regex = /^[-+]?[0-9]?(\.[0-9]+)?$+/
      @word_regex = /\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/
      @non_wordchar_regex = /\W+/
      @dictionary = Hash.new(1)
      load
    end

    # Interrogates the dictionary to determine whether or not [word] exists.
    #
    # @param [String] word the word or words to interrogate
    # @param [Hash] options options to apply to this query (see #options=).  Options passed to this
    #   method are applied for this query only.
    #
    # @return [Boolean] true if the word/words in *word* exists, false otherwise.
    #
    # @example
    #
    #  LittleWeasel::Checker.instance.exists?('C') # true (default options, :exclude_alphabet => false)
    #  LittleWeasel::Checker.instance.exists?('A', {exclude_alphabet:true}) # false
    #  LittleWeasel::Checker.instance.exists?('X', {exclude_alphabet:false}) # true
    #  LittleWeasel::Checker.instance.exists?('Hello') # true
    #
    #  LittleWeasel::Checker.instance.exists?(' Hello ') # false (default options, :strip_whitespace => false)
    #  LittleWeasel::Checker.instance.exists?(' Yes ', {strip_whitespace:true}) # true
    #  LittleWeasel::Checker.instance.exists?('No ', {strip_whitespace:false}) # false
    #  LittleWeasel::Checker.instance.exists?('How dy', {strip_whitespace:true}) # false, strip_whitespace only removes leading and trailing spaces
    #
    #  LittleWeasel::Checker.instance.exists?('90210') # true (default options, ignore_numeric => true)
    #  LittleWeasel::Checker.instance.exists?('90210', {ignore_numeric:false}) # false
    #
    #  LittleWeasel::Checker.instance.exists?('Hello World') # true, we're accepting multiple words now by default (default options, single_word_mode => false) :)
    #  LittleWeasel::Checker.instance.exists?("hello, mister; did I \'mention\'' that lemon cake is \"great?\" It's just wonderful!") # true
    #
    #  LittleWeasel::Checker.instance.exists?('I love ice cream', {single_word_mode:true}) # false; while all the words are valid, more than one word will return false
    #
    def exists?(word, options=nil)
      options = options || @options

      return false unless word.is_a?(String)

      word = word.dup
      word.strip! if options[:strip_whitespace]

      return false if word.empty?

      if block? word
        return false if options[:single_word_mode]
        return block_exists? word
      end
      
      return true if options[:ignore_numeric] && number?(word)
      return false if options[:exclude_alphabet] && word.length == 1 && @alphabet_exclusion_list.include?(word.upcase)

      valid_word? word
    end

    # Sets the global options for this gem.
    #
    # @param [Hash] options options that should apply to all subsequent calls to method *exists?* (see #exists?).
    #  Options set via this property apply to all subsequent queries.
    #
    # @option options [Boolean] :exclude_alphabet (false) If false, letters of the alphabet are considered words.
    # @option options [Boolean] :strip_whitespace (false) If true, leading and trailing spaces are removed before checking to see if the word exists.
    # @option options [Boolean] :ignore_numeric (true) If true, numeric values are considered valid words.
    # @option options [Boolean] :single_word_mode (false) If false, word blocks (more than one word) are considered valid if all the words exist in the dictionary.
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
    #  LittleWeasel::Checker.instance.exists?('How dy') # false, strip_whitespace only removes leading and trailing spaces
    #
    #  LittleWeasel::Checker.instance.exists?('90210') # true (default options, ignore_numeric => true)
    #  LittleWeasel::Checker.instance.exists?('90210', {ignore_numeric:false}) # false
    #  LittleWeasel::Checker.instance.exists?('I watch Beverly Hills 90210') # true (default options, ignore_numeric => true)
    #  LittleWeasel::Checker.instance.exists?('I watch Beverly Hills 90210', {ignore_numeric:false}) # false
    #
    #  LittleWeasel::Checker.instance.options({single_word_mode:true})
    #  LittleWeasel::Checker.instance.exists?('I love ice cream') # false; while all the words are valid, more than one word will return false
    #  LittleWeasel::Checker.instance.exists?('Baby') # true
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

    protected

    def number?(word)
      word.strip.gsub(@numeric_regex).count > 0
    end

    def block?(string)
      string = string.dup
      return false unless string.is_a?(String)
      string.gsub!(@numeric_regex, "")
      return false unless string.length > 1
      string.strip.scan(/[\w'-]+/).length > 1
    end

    def block_exists?(word_block)
      word_block = word_block.dup

      word_block.gsub!(@numeric_regex, "") if options[:ignore_numeric]
      return false if word_block.nil?
      word_block.strip! unless word_block.nil?
      word_block.gsub!(@non_wordchar_regex, " ")
      word_block.split(@word_regex).uniq.each { |word|
        return false unless valid_block_word?(word)
      }
      return true
    end

    def valid_word?(word)
      word = word.dup.downcase
      exists = dictionary.has_key?(word)
      exists = dictionary.has_key?(word.singularize) unless exists
      exists
    end

    def valid_block_word?(word)
      return true if word.length == 1
      valid_word? word.strip
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