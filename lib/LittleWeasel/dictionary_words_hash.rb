# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'


# TODO: What to do if the configuration changes for options
# affecting max_invalid_words_bytesize? e.g.
# max_invalid_words_bytesize, max_invalid_words_bytesize?.
# All (individual?) dictionaries metadata would need to be
# reset.
module LittleWeasel
  class DictionaryWordsHash
    delegate :count, to: :dictionary_words_hash

    def initialize(dictionary_words)
      raise ArgumentError unless dictionary_words.is_a?(Array)

      self.dictionary_words_hash = to_hash dictionary_words
    end

    def [](word)
      _cached, found = cache_word_if! word
      found
    end

    private

    # TODO: Update the metadata current_invalid_word_bytesize
    # and other appropriate metadata values.
    def cache_word_if!(word)
      return [true, true] if word_found? word

      cache = cache_word? word
      if cache
        dictionary_words_hash[word] = false
        metadata = max_invalid_words_bytesize_metadata

        # TODO: Update the cache
        metadata[:value_exceeded?] exceeded,
        current_invalid_word_bytesize: current_bytesize,
        cache_invalid_words?: max_invalid_words_bytesize? && !exceeded
      end

      [cache, false]
    end

    def cache_word?(word)
      return true if word_found?(word)

      metadata = max_invalid_words_bytesize_metadata
      return false unless metadata[:cache_invalid_words?]

      metadata[:value] > (word.bytesize + metadata[:current_invalid_word_bytesize])
    end

    def word_found?(word)
      dictionary_words_hash.include?(word)
    end

    def max_invalid_words_bytesize_metadata
      @max_invalid_words_bytesize_metadata ||= metadata[:max_invalid_words_bytesize]
    end

    def to_hash(dictionary_words)
      dictionary_words.each_with_object(Hash.new(false)) { |word, hash| hash[word] = true; }
    end

    attr_accessor :dictionary_words_hash
  end
end
