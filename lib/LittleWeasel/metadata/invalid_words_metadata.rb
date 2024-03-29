# frozen_string_literal: true

require_relative '../modules/class_name_to_symbol'
require_relative '../modules/configurable'
require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../services/invalid_words_service'
require_relative 'metadata_observerable'

module LittleWeasel
  module Metadata
    # This class provides the ability to cache words not found in the
    # associated dictionary.
    class InvalidWordsMetadata
      include Metadata::MetadataObserverable
      include Modules::ClassNameToSymbol
      include Modules::Configurable
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryKeyable
      include Modules::DictionaryMetadataServicable

      delegate :on?, :off?, :value, :value_exceeded?,
        :current_invalid_word_bytesize, :cache_invalid_words?,
        to: :metadata

      attr_reader :dictionary_metadata_object

      def initialize(dictionary_metadata_object:, dictionary_metadata:,
        dictionary_cache:, dictionary_key:, dictionary_words:)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache

        validate_dictionary_metadata dictionary_metadata: dictionary_metadata
        self.dictionary_metadata = dictionary_metadata

        unless dictionary_metadata_object.is_a? Observable
          raise ArgumentError,
            "Argument dictionary_metadata_object is not an Observable: #{dictionary_metadata_object.class}."
        end

        dictionary_metadata_object.add_observer self
        self.dictionary_metadata_object = dictionary_metadata_object

        unless dictionary_words.is_a? Hash
          raise ArgumentError,
            "Argument dictionary_words is not a Hash: #{dictionary_words.class}."
        end

        self.dictionary_words = dictionary_words
      end

      class << self
        def metadata_key
          to_sym
        end

        def observe?
          config.max_invalid_words_bytesize?
        end
      end

      # rubocop: disable Lint/UnusedMethodArgument
      def init(params: nil)
        dictionary_metadata_service.init(metadata_key: metadata_key)
        self.metadata = Services::InvalidWordsService.new(dictionary_words).execute
        self
      end
      # rubocop: enable Lint/UnusedMethodArgument

      # rubocop: disable Lint/UnusedMethodArgument
      def refresh(params: nil)
        refresh_local_metadata
        init unless metadata.present?
        self
      end
      # rubocop: enable Lint/UnusedMethodArgument

      # This method is called when a word is being searched in the
      # dictionary.
      def word_search(params:)
        word_results = params[:word_results]

        # TODO: NOW: Should we be returning #word_valid? or #success?
        return word_results.word_valid? if word_results.word_cached?

        # If we get here, we know that the word is NOT in the dictionary either
        # as a valid word OR as a cached, INVALID word.

        # If caching is supposed to take place, cache the word as invalid
        # (not found).
        word = word_results.preprocessed_word_or_original_word
        dictionary_words[word] = false if cache_word? word
        false
      end

      def update(action, params)
        unless actions_whitelist.include? action
          raise ArgumentError,
            "Argument action is not in the actions_whitelist: #{action}"
        end

        send(action, params: params)
        self
      end

      def actions_whitelist
        %i[init refresh word_search]
      end

      private

      attr_accessor :dictionary_words
      attr_writer :dictionary_metadata_object

      def cache_word?(word)
        return false unless metadata.cache_invalid_words?

        if metadata.value >= (word.bytesize + metadata.current_invalid_word_bytesize)
          metadata.current_invalid_word_bytesize += word.bytesize
          true
        else
          false
        end
      end

      def update_dictionary_metadata(value:)
        dictionary_metadata_service.set_dictionary_metadata(value: value, metadata_key: metadata_key)
      end
    end
  end
end
