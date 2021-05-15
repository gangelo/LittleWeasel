# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'modules/dictionary_words_hash_metadata'

# TODO: What to do if the configuration changes for options
# affecting max_invalid_words_bytesize? e.g.
# max_invalid_words_bytesize, max_invalid_words_bytesize?.
# All (individual?) dictionaries metadata would need to be
# reset.
module LittleWeasel
  class DictionaryWordsHash
    include Modules::DictionaryWordsHashMetadata

    delegate :count, to: :dictionary_words_hash

    def initialize(dictionary_words)
      self.dictionary_words_hash = to_hash dictionary_words
    end

    def [](word)
      cached, found = cache_word_if! word
      found
    end

    private

    # TODO: Update the metadata current_invalid_word_bytesize
    # and other appropriate metadata values.
    def cache_word_if!(word)
      return [true, true] if word_found? word

      cache = cache_word? word
      dictionary_words_hash[word] = false if cache

      [cache, false]
    end

    def cache_word?(word)
      return true if word_found?(word)

      _metadata = max_invalid_words_bytesize_metadata
      return false unless _metadata[:cache_invalid_words?]

      _metadata[:value] > (word.bytesize + _metadata[:current_invalid_word_bytesize])
    end

    def word_found?(word)
      dictionary_words_hash.include?(word)
    end

    def max_invalid_words_bytesize_metadata
      @max_invalid_words_bytesize_metadata ||= metadata[:max_invalid_words_bytesize]
    end

    def to_hash(dictionary_words)
      dictionary_words.reduce(Hash.new(false)) { |hash, word| hash[word] = true; hash }
    end

    attr_accessor :dictionary_words_hash
  end
end
