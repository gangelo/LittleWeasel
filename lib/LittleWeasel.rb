require 'singleton'
require "LittleWeasel/version"

module LittleWeasel

  class Checker
    include Singleton

    attr_reader :dictionary

    def initialize
      @dictionary = Hash.new(1)
      load
    end

    def exists?(word)
      dictionary.has_key? word
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