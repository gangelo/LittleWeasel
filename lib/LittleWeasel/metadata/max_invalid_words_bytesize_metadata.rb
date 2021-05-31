# frozen_string_literal: true

require_relative '../modules/metadata_observer'
require_relative '../services/dictionary_service'
require_relative '../services/max_invalid_words_bytesize_service'

module LittleWeasel
  module Metadata
    class MaxInvalidWordsBytesizeMetadata < Services::DictionaryService
      include Modules::MetadataObserver

      delegate :on?, :off?, :value, :value_exceeded?,
        :current_invalid_word_bytesize, :cache_invalid_words?,
        to: :metadata

      attr_reader :dictionary_metadata

      def initialize(dictionary_metadata:, dictionary:, dictionary_key:, dictionary_cache:)
        super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

        raise ArgumentError unless dictionary_metadata.is_a? Observable
        raise ArgumentError unless dictionary.is_a? Hash

        dictionary_metadata.add_observer self
        self.dictionary_metadata = dictionary_metadata

        self.dictionary = dictionary
      end

      class << self
        def metadata_key
          'max_invalid_words_bytesize'
        end
      end

      def refresh!
        self.metadata = Services::MaxInvalidWordsByteSizeService.new(dictionary).execute
        self
      end

      def update(action, **args)
        raise ArgumentError unless actions_whitelist.include? action

        send(action)
        self
      end

      private

      attr_accessor :dictionary
      attr_writer :dictionary_metadata

      def init!
        self.metadata = dictionary_cache_service.dictionary_metadata(metadata_key: self.class.metadata_key)
        refresh! unless metadata
        self
      end
    end
  end
end
