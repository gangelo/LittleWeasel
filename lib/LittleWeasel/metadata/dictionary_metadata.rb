# frozen_string_literal: true

require 'observer'
require_relative '../modules/metadata'
require_relative 'max_invalid_words_bytesize_metadata'

module LittleWeasel
  module Metadata
    class DictionaryMetadata
      include Observable
      include Modules::Metadata

      METADATA_KEY = :'$$metadata$$'

      attr_reader :dictionary

      def initialize(dictionary)
        raise ArgumentError, "Argument dictionary (#{dictionary.class.name})" unless dictionary.is_a? Hash

        self.dictionary = dictionary

        # Conditionally initialize the root Hash - we don't want to
        # wipe out any metadata that already exists.
        init_if with: {}
      end

      def refresh!
        init_if with: {}
        notify :refresh!
        self
      end

      def to_hash(include_root: false)
        metadata = dictionary[METADATA_KEY]
        return { METADATA_KEY => metadata } if include_root
        metadata
      end

      def add_observers(&block)
        return yield(add_observers_with_block(&block)) if block_given?

        self.class.add_observers(dictionary) do |observer_classes|
          observer_classes.each do |o|
            add_observer o.new(self)
          end
        end
        self
      end

      class << self
        def add_observers(dictionary)
          # Add additional observers here.
          observer_classes = [MaxInvalidWordsBytesizeMetadata]
          return (yield observer_classes) if block_given?

          new(dictionary).tap do |dictionary_metadata|
            observer_classes.each do |o|
              dictionary_metadata.add_observer o.new(dictionary_metadata)
            end
          end
        end
      end

      private

      attr_writer :dictionary

      def add_observers_with_block(&block)
        self.class.add_observers(dictionary) do |observer_classes|
          yield observer_classes
        end
        self
      end

      def notify(action)
        changed
        notify_observers action
      end

      def init
        init! unless init_data?
        self
      end

      def init!
        init_if with: {}
        notify :init!
        self
      end

      def init_data(with:, **args)
        dictionary[METADATA_KEY] = with
      end

      def init_needed?
        !(dictionary.key?(METADATA_KEY) &&
          dictionary[METADATA_KEY].is_a?(Hash))
      end
    end
  end
end
