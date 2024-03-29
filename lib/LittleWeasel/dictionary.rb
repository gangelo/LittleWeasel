# frozen_string_literal: true

require_relative 'block_results'
require_relative 'filters/word_filter_managable'
require_relative 'metadata/dictionary_metadata'
require_relative 'modules/configurable'
require_relative 'modules/dictionary_cache_servicable'
require_relative 'modules/dictionary_keyable'
require_relative 'modules/dictionary_metadata_servicable'
require_relative 'preprocessors/word_preprocessor_managable'
require_relative 'word_results'

module LittleWeasel
  class Dictionary
    include Filters::WordFilterManagable
    include Modules::Configurable
    include Modules::DictionaryCacheServicable
    include Modules::DictionaryKeyable
    include Modules::DictionaryMetadataServicable
    include Preprocessors::WordPreprocessorManagable

    attr_reader :dictionary_metadata_object, :dictionary_words

    def initialize(dictionary_key:, dictionary_words:, dictionary_cache:, # rubocop:disable Metrics/ParameterLists
      dictionary_metadata:, word_filters: nil, word_preprocessors: nil)
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

      # Set up the dictionary metadata object and observers
      self.dictionary_words = self.class.to_hash(dictionary_words: dictionary_words)
      self.dictionary_metadata_object = create_dictionary_metadata
      dictionary_metadata_object.add_observers

      add_filters word_filters: word_filters || []
      add_preprocessors word_preprocessors: word_preprocessors || []
    end

    class << self
      def to_hash(dictionary_words:)
        dictionary_words.each_with_object(Hash.new(false)) { |word, hash| hash[word] = true }
      end
    end

    def word_results(word)
      # TODO: Make max word size configurable.
      raise ArgumentError, "Argument word is not a String: #{word.class}" unless word.is_a?(String)

      preprocessed_words = preprocess(word: word)
      preprocessed_word = preprocessed_words.preprocessed_word
      filters_matched = filters_matched(preprocessed_word || word)
      word_results = WordResults.new(original_word: word,
        filters_matched: filters_matched,
        preprocessed_words: preprocessed_words,
        word_cached: dictionary_words.include?(preprocessed_word || word),
        word_valid: dictionary_words[preprocessed_word || word] || false)

      dictionary_metadata_object.notify(action: :word_search,
        params: { word_results: word_results })

      word_results
    end

    def block_results(word_block)
      # TODO: Make max word_block size configurable.
      raise ArgumentError, "Argument word_block is not a String: #{word_block.class}" unless word_block.is_a?(String)
      raise ArgumentError, "Argument word_block is empty: #{word_block.class}" unless word_block.present?

      BlockResults.new(original_word_block: word_block).tap do |block_results|
        word_block.scan(config.word_block_regex)&.map do |word|
          block_results << word_results(word)
        end
      end
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

    def create_dictionary_metadata
      # We unconditionally attach metadata to this dictionary. DictionaryMetadata
      # only attaches the metadata services that are turned "on".
      Metadata::DictionaryMetadata.new(
        dictionary_words: dictionary_words,
        dictionary_key: dictionary_key,
        dictionary_cache: dictionary_cache,
        dictionary_metadata: dictionary_metadata
      )
    end
  end
end
