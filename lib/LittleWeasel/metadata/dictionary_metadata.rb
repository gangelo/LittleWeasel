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

      def init!(_params: nil)
        metadata = dictionary_cache_service.dictionary_metadata
        if metadata
          self.metadata = metadata
          notify action: :init!
        else
          refresh!
        end
      end

      def refresh!(_params: nil)
        self.metadata = {}
        notify action: :refresh!
        self
      end

      def notify(action:, params: nil)
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
        end
        # This is how each metadata object gets initialized.
        notify(action: :init!) if observer_classes.any?
        self
      end

      def add_observer(observer, func = :update)
        super

        return unless observer.respond_to? :to_sym

        observers[observer.to_sym] = {
          metadata_key: observer.metadata_key,
          metadata_object: observer
        }
      end

      def delete_observer(observer)
        super

        return unless observer.respond_to? :to_sym

        observers.delete(observer.to_sym)
      end

      def delete_observers
        super
        self.observers = {}
      end

      private

      attr_writer :dictionary, :observers

      def update_dictionary_metadata(value:)
        dictionary_cache_service.dictionary_metadata_set(value: value)
      end
    end
  end
end
