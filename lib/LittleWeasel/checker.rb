require 'singleton'

module LittleWeasel

  class Checker
    include Singleton

    attr_reader :dictionary

    def initialize
      @dictionary = Hash.new(1)
      train
    end

    def exists?(word)
      dictionary.has_key? word
    end

    private

    def dictionary_path
      File.expand_path(File.dirname(__FILE__) + '/dictionary')
    end

    def letters
      ('a'..'z').to_a.join
    end

    def train
      File.open(dictionary_path) do |io|
        # Read every line of dictionary and
        # set the populariy weight to 1 for now
        # FIXME: Load a language model to set weight based on words repition
        io.each { |line| line.chomp!; @dictionary[line] = 1 }
      end
    end

    def known_candidates(suggested)
      results = []
      suggested.find_all { |w| dictionary.has_key?(w) }
      results.empty? ? nil : results
    end

    # Return set of possible corrections of the given word.
    # Can be deletions, transpositions, alterations or insertions
    def edits(word)

      results = []
      word_length = word.length

      # deletions
      (0...word_length).each do |i|
        results.push(word[0...i] + word[i+1..-1])
      end

      # transpositions
      (0...word_length - 1).each do |i|
        results.push(word[0...i] + word[i+1, 1] + word[i, 1] + word[i+2..-1])
      end

      # alterations
      word_length.times do |i|
        letters.each_byte do |l|
          results.push(word[0...i] + l.chr + word[i+1..-1])
        end
      end

      # insertions
      (word_length + 1).times do |i|
        letters.each_byte do |l|
          results.push(word[0...i] + l.chr + word[i..-1])
        end
      end

      results
    end


    # Return set of possible corrections with edit distance 2
    # if known by the dictionary
    def edits_2 word
      results = []
      edits(word).each { |e1| edits(e1).each { |e2| results << e2 if dictionary.has_key?(e2) } }
      results
    end

  end
end