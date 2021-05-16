# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'metadata/dictionary_metadata'

# TODO: What to do if the configuration changes for options
# affecting max_invalid_words_bytesize? e.g.
# max_invalid_words_bytesize, max_invalid_words_bytesize?.
# All (individual?) dictionaries metadata would need to be
# reset.
module LittleWeasel
  class Dictionary
    delegate :count, to: :dictionary

    attr_reader :dictionary

    def initialize(dictionary_words)
      raise ArgumentError unless dictionary_words.is_a?(Array)

      self.dictionary = to_hash dictionary_words
      # We unconditionally attach metadata to the dictionary. DictionaryMetadata
      # only attaches the metadata services that are turned "on".
      self.dictionary_metadata = LittleWeasel::Metadata::DictionaryMetadata.new(dictionary)
      self.dictionary_metadata.add_observers
    end

    def [](word)
      dictionary.include? word
    end

    private

    attr_writer :dictionary
    attr_accessor :dictionary_metadata

    def to_hash(dictionary_words)
      dictionary_words.each_with_object(Hash.new(false)) { |word, hash| hash[word] = true; }
    end
  end
end
