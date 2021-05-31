# frozen_string_literal: true

require 'observer'
require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/metadata'
require_relative '../services/dictionary_service'
require_relative 'max_invalid_words_bytesize_metadata'

module LittleWeasel
  module Metadata
    class DictionaryMetadata < Services::DictionaryService
      include Observable
      include Modules::DictionaryCacheKeys
      include Modules::Metadata

      attr_reader :dictionary

      def initialize(dictionary:, dictionary_key:, dictionary_cache:)
        super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

        raise ArgumentError, "Argument dictionary is not a Hash: #{dictionary.class.name}." unless dictionary.is_a? Hash

        self.dictionary = dictionary

        init!
      end

      def refresh!
        self.metadata = {}
        notify :refresh!
        self
      end

      def add_observers
        observer_classes = [MaxInvalidWordsBytesizeMetadata]
        yield observer_classes if block_given?

        observer_classes.each do |o|
          add_observer o.new(dictionary_metadata: self,
                             dictionary: dictionary,
                             dictionary_key: dictionary_key,
                             dictionary_cache: dictionary_cache)
        end
        # This is how each metadata object gets initialized.
        notify(:init!) if observer_classes.any?
        self
      end

      private

      attr_writer :dictionary

      def init!
        self.metadata = dictionary_cache_service.dictionary_metadata
        if metadata
          notify :init!
        else
          refresh!
        end
      end

      def notify(action)
        changed
        notify_observers action
        self
      end
    end
  end
end
