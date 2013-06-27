require 'singleton'
require "LittleWeasel/version"

module LittleWeasel

  class Checker
    include Singleton

    attr_reader :dictionary

    private

    attr_reader :alphanet_exclusion_list

    public

    def initialize
      @options = {exclude_alphabet: false}
      @alphabet_exclusion_list = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z }
      @dictionary = Hash.new(1)
      load
    end

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