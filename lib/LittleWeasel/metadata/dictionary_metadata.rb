# frozen_string_literal: true

require 'observer'
require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/klass_name_to_sym'
require_relative '../modules/metadata'
require_relative '../services/dictionary_service'
require_relative 'max_invalid_words_bytesize_metadata'

module LittleWeasel
  module Metadata
    class DictionaryMetadata < Services::DictionaryService
      include Observable
      include Modules::DictionaryCacheKeys
      include Modules::KlassNameToSym
      include Modules::Metadata

      attr_reader :dictionary, :observers

      def initialize(dictionary:, dictionary_key:, dictionary_cache:)
        super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

        raise ArgumentError, "Argument dictionary is not a Hash: #{dictionary.class.name}." unless dictionary.is_a? Hash

        self.dictionary = dictionary
        self.observers = {}

        init!
      end

      def refresh!(params: nil)
        self.metadata = {}
        notify action: :refresh!
        self
      end

      def notify(action:, params: nil)
        binding.pry
        changed
        notify_observers action, params
        self
      end

      def add_observers
        self.observers = {}
        observer_classes = [MaxInvalidWordsBytesizeMetadata]
        yield observer_classes if block_given?

        observer_classes.each do |o|
          observer = o.new(dictionary_metadata: self,
                             dictionary: dictionary,
                             dictionary_key: dictionary_key,
                             dictionary_cache: dictionary_cache)
          add_observer observer
          self.observers[observer.to_sym] = observer.metadata_key
        end
        # This is how each metadata object gets initialized.
        notify(action: :init!) if observer_classes.any?
        self
      end

      private

      attr_writer :dictionary, :observers

      def init!(params: nil)
        self.metadata = dictionary_cache_service.dictionary_metadata
        if metadata
          notify action: :init!
        else
          refresh!
        end
      end
    end
  end
end
