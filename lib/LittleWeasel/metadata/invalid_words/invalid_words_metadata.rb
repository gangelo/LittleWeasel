# frozen_string_literal: true

require_relative '../../modules/klass_name_to_sym'
require_relative '../../services/dictionary_service'
require_relative '../../services/invalid_words_service'
require_relative '../metadata_observerable'

module LittleWeasel
  module Metadata
    module InvalidWords
      class InvalidWordsMetadata < Services::DictionaryService
        include Metadata::MetadataObserverable
        include Modules::KlassNameToSym

        delegate :on?, :off?, :value, :value_exceeded?,
          :current_invalid_word_bytesize, :cache_invalid_words?,
          to: :metadata

        attr_reader :dictionary_metadata

        def initialize(dictionary_metadata:, dictionary_words:, dictionary_key:, dictionary_cache:)
          super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

          unless dictionary_metadata.is_a? Observable
            raise ArgumentError,
              "Argument dictionary_metadata is not an Observable: #{dictionary_metadata.class}."
          end
          unless dictionary_words.is_a? Hash
            raise ArgumentError,
              "Argument dictionary_words is not a Hash: #{dictionary_words.class}."
          end

          dictionary_metadata.add_observer self
          self.dictionary_metadata = dictionary_metadata
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
        def init!(params: nil)
          metadata = dictionary_cache_service.dictionary_metadata(metadata_key: metadata_key)
          if metadata
            self.metadata = metadata
          else
            refresh!
          end
          self
        end
        # rubocop: enable Lint/UnusedMethodArgument

        # rubocop: disable Lint/UnusedMethodArgument
        def refresh!(params: nil)
          self.metadata = Services::InvalidWordsService.new(dictionary_words).execute
          self
        end
        # rubocop: enable Lint/UnusedMethodArgument

        # This method is called when a word is being searched in the
        # dictionary.
        def word_search(params:)
          word, word_found, word_valid = params.fetch_values(:word, :word_found, :word_valid)

          return word_valid if word_found

          # If we get here, we know that the word is NOT in the
          # dictionary, either as a valid word; or, as a cached,
          # invalid word.

          # Cache the word as invalid (not found) if caching is
          # supposed to take place.
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
          %i[init! refresh! word_search]
        end

        private

        attr_accessor :dictionary_words
        attr_writer :dictionary_metadata

        def cache_word?(word)
          return false unless metadata.cache_invalid_words?

          if metadata.value > (word.bytesize + metadata.current_invalid_word_bytesize)
            metadata.current_invalid_word_bytesize += word.bytesize
            true
          else
            false
          end
        end

        def update_dictionary_metadata(value:)
          dictionary_cache_service.dictionary_metadata_set(metadata_key: metadata_key, value: value)
        end
      end
    end
  end
end
