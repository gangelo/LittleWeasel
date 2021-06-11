# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'metadata/dictionary_metadata'
require_relative 'modules/dictionary_cache_servicable'
require_relative 'modules/dictionary_keyable'
require_relative 'modules/dictionary_metadata_servicable'

module LittleWeasel
  class Dictionary
    include Modules::DictionaryCacheServicable
    include Modules::DictionaryKeyable
    include Modules::DictionaryMetadataServicable

    attr_reader :dictionary_metadata_object, :dictionary_words

    def initialize(dictionary_key:, dictionary_words:, dictionary_cache:, dictionary_metadata:)
      validate_dictionary_key dictionary_key: dictionary_key
      self.dictionary_key = dictionary_key

      validate_dictionary_cache dictionary_cache: dictionary_cache
      self.dictionary_cache = dictionary_cache

      validate_dictionary_metadata dictionary_metadata: dictionary_metadata
      self.dictionary_metadata = dictionary_metadata

      unless dictionary_words.is_a?(Array)
        raise ArgumentError,
          "Argument dictionary_words is not an Array: #{dictionary_words.class}"
      end

      self.dictionary_words = self.class.to_hash(dictionary_words: dictionary_words)
      # We unconditionally attach metadata to this dictionary. DictionaryMetadata
      # only attaches the metadata services that are turned "on".
      self.dictionary_metadata_object =
        Metadata::DictionaryMetadata.new(
          dictionary_words: self.dictionary_words,
          dictionary_key: dictionary_key,
          dictionary_cache: dictionary_cache,
          dictionary_metadata: dictionary_metadata
        )
      dictionary_metadata_object.add_observers
    end

    class << self
      def to_hash(dictionary_words:)
        dictionary_words.each_with_object(Hash.new(false)) { |word, hash| hash[word] = true; }
      end
    end

    def word_valid?(word)
      # <word_found> tells us whether or not <word> can be found in the
      # dictionary_words.
      #
      # <word_valid> tells us whether or not the word is a valid word in
      # the dictionary_words.
      #
      # Words found in the dictionary_words don't necessarily mean the word
      # is valid; invalid words can also be found in the dictionary_words
      # if the invalid words metadata functionality is using it to cache
      # invalid words.
      #
      # No matter what the case, we need to notify any metadata observers
      # of this information so that they can perform their processing.
      word_found = dictionary_words.include?(word)
      word_valid = dictionary_words[word] || false
      dictionary_metadata_object.notify(action: :word_search,
        params: { word: word, word_found: word_found, word_valid: word_valid })
      word_valid
    end

    # This method returns true if this dictionary object is detached from the
    # dictionary cache; this can happen if the dictionary object is unloaded
    # from the dictionary cache(DictionaryManager#unload_dictionary) or the
    # dictionary is killed (DictionaryManager#kill_dictionary).
    def detached?
      !dictionary_cache_service.dictionary_object?
    end

    # This method returns a count of VALID words in the dictionary.
    def count
      dictionary_words.each_pair.count { |_word, valid| valid }
    end

    # This method returns a count of all VALID and INVALID words in
    # the dictionary.
    def count_all_words
      dictionary_words.count
    end

    # This method returns a count of all INVALID words in the dictionary.
    def count_invalid_words
      dictionary_words.each_pair.count { |_word, valid| !valid }
    end

    private

    attr_writer :dictionary_metadata_object, :dictionary_words
  end
end
