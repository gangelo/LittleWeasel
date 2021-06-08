# frozen_string_literal: true

require 'observer'
require_relative '../modules/configurable'
require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_metadata_servicable'
require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/klass_name_to_sym'
require_relative 'metadata_observable_validatable'
require_relative 'metadatable'

module LittleWeasel
  module Metadata
    # This class manages metadata objects related to dictionaries. Metadata
    # objects defined in LittleWeasel::Configuration#metadata_observers are
    # added as observers, provided they are in a state to observe (see
    # Metadata::Metadatable, Metadata::InvalidWords::InvalidWordsMetadata, etc.).
    class DictionaryMetadata
      include Observable
      include Modules::Configurable
      include Modules::DictionaryCacheKeys
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryMetadataServicable
      include Modules::KlassNameToSym
      include Metadata::Metadatable
      include Metadata::MetadataObservableValidatable

      attr_reader :dictionary_words, :observers

      def initialize(dictionary_words:, dictionary_key:, dictionary_cache:, dictionary_metadata:)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache

        validate_dictionary_metadata dictionary_metadata: dictionary_metadata
        self.dictionary_metadata = dictionary_metadata

        unless dictionary_words.is_a? Hash
          raise ArgumentError,
            "Argument dictionary_words is not a Hash: #{dictionary_words.class.name}."
        end

        self.dictionary_words = dictionary_words
        self.observers = {}

        refresh!
      end

      def init(_params: nil)
        dictionary_metadata_service.init(metadata_key: metadata_key)
        self.metadata = {}
        notify action: :init
        refresh_local_metadata
        if count_observers.positive? && metadata.blank?
          raise 'Observers were notified to #init ' \
            'but no observers initialized their respective dictionary cache metadata'
        end

        self
      end

      def refresh!(_params: nil)
        refresh_local_metadata
        if metadata.present?
          # If there is metadata in the dictionary cache, notify the observers
          # to use it...
          notify action: :refresh!
        else
          # ...otherwise, notify the observers to initialize themselves.
          init
        end
      end

      def notify(action:, params: nil)
        if count_observers.positive?
          changed
          notify_observers action, params
        end
        self
      end

      def add_observers(force: false)
        delete_observers if force

        raise 'Observers have already been added; use #add_observers(force: true) instead' if count_observers.positive?

        observer_classes = config.metadata_observers
        yield observer_classes if block_given?

        observer_classes.each do |o|
          # If the medatata observer is not in a state to observe,
          # or is turned "off", skip it...
          #
          # See Metadata::MetadataObserverable.observe? comments.
          next unless o.observe?

          # If this observer has already beed added, don't add it again.
          next if observers.key? o.metadata_key

          observer = o.new(dictionary_metadata_object: self,
            dictionary_words: dictionary_words,
            dictionary_key: dictionary_key,
            dictionary_cache: dictionary_cache,
            dictionary_metadata: dictionary_metadata)

          # Only add metadata objects that are capable of observing
          # (i.e. #observe?).
          add_observer observer if observer.observe?
        end
        # This is how each metadata object gets initialized. Only notify if
        # there are any observers.
        notify(action: :init) if count_observers.positive?
        self
      end

      def add_observer(observer, func = :update)
        validate_metadata_observable observer

        super
        observers[observer.metadata_key] = observer
      end

      def delete_observer(observer)
        validate_metadata_observable observer

        super
        observers.delete(observer.metadata_key)
      end

      def delete_observers
        super
        self.observers = {}
      end

      private

      attr_writer :dictionary_words, :observers

      def update_dictionary_metadata(value:)
        dictionary_metadata_service.set_dictionary_metadata(value: value, metadata_key: metadata_key)
      end
    end
  end
end
