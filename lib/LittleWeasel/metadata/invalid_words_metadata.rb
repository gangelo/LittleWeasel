# frozen_string_literal: true

require_relative '../modules/klass_name_to_sym'
require_relative '../services/dictionary_service'
require_relative '../services/invalid_words_metadata_service'
require_relative 'invalid_words_cacheable'
require_relative 'metadata_observerable'

module LittleWeasel
  module Metadata
    class InvalidWordsMetadata < Services::DictionaryService
      include Metadata::InvalidWordsCacheable
      include Metadata::MetadataObserverable
      include Modules::KlassNameToSym

      delegate :on?, :off?, :value, :value_exceeded?,
        :current_invalid_word_bytesize, :cache_invalid_words?,
        to: :metadata

      attr_reader :dictionary_metadata

      def initialize(dictionary_metadata:, dictionary:, dictionary_key:, dictionary_cache:)
        super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

        unless dictionary_metadata.is_a? Observable
          raise ArgumentError,
            "Argument dictionary_metadata is not an Observable: #{dictionary_metadata.class}."
        end
        raise ArgumentError, "Argument dictionary is not a Hash: #{dictionary.class}." unless dictionary.is_a? Hash

        dictionary_metadata.add_observer self
        self.dictionary_metadata = dictionary_metadata
        self.dictionary = dictionary
      end

      class << self
        def metadata_key
          to_sym
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
        self.metadata = Services::InvalidWordsMetadataService.new(dictionary).execute
        self
      end
      # rubocop: enable Lint/UnusedMethodArgument

      # This method is called when a word is being searched in the
      # dictionary.
      def search(params:)
        word_valid? params[:word]
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
        %i[init! refresh! search]
      end

      private

      attr_accessor :dictionary
      attr_writer :dictionary_metadata

      def update_dictionary_metadata(value:)
        dictionary_cache_service.dictionary_metadata_set(metadata_key: metadata_key, value: value)
      end
    end
  end
end
