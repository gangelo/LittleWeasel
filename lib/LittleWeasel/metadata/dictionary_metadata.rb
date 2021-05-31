# frozen_string_literal: true

require 'observer'
require_relative '../modules/dictionary_cache_keys'
require_relative '../services/dictionary_service'
require_relative 'max_invalid_words_bytesize_metadata'

module LittleWeasel
  module Metadata
    class DictionaryMetadata < Services::DictionaryService
      include Observable
      include Modules::DictionaryCacheKeys

      attr_reader :dictionary

      def initialize(dictionary:, dictionary_key:, dictionary_cache:)
        super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

        raise ArgumentError, "Argument dictionary is not a Hash: #{dictionary.class.name}." unless dictionary.is_a? Hash

        self.dictionary = dictionary

        init!
      end

      # class << self
      #   def add_observers(dictionary:, dictionary_key:, dictionary_cache:)
      #     # Add additional observers here.
      #     observer_classes = [MaxInvalidWordsBytesizeMetadata]
      #     return (yield observer_classes) if block_given?

      #     return new(dictionary: dictionary,
      #         dictionary_key: dictionary_key,
      #         dictionary_cache: dictionary_cache).tap do |dictionary_metadata|
      #       observer_classes.each do |o|
      #         dictionary_metadata.add_observer o.new(dictionary_metadata: dictionary_metadata,
      #                                                dictionary: dictionary,
      #                                                dictionary_key: dictionary_key,
      #                                                dictionary_cache: dictionary_cache)
      #       end
      #       # This is how each metadata object gets initialized.
      #       dictionary_metadata.send(:notify, :init!) if observer_classes.any?
      #     end
      #   end
      # end

      def refresh!
        self.metadata = {}
        notify :refresh!
        self
      end

      def add_observers
        # return yield(add_observers_with_block(&block)) if block_given?

        # self.class.add_observers(dictionary: dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

        # self.class.add_observers(dictionary, dictionary_key, dictionary_cache) do |observer_classes|
        #   observer_classes.each do |o|
        #     add_observer o.new(dictionary_metadata: self,
        #                        dictionary: dictionary,
        #                        dictionary_key: dictionary_key,
        #                        dictionary_cache: dictionary_cache)
        #   end
        #   # This is how each metadata object gets initialized.
        #   notify(:init!) if observer_classes.any?
        # end

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

      attr_reader :metadata
      attr_writer :dictionary

      # def add_observers_with_block(&block)
      #   self.class.add_observers(dictionary, dictionary_key, dictionary_cache) do |observer_classes|
      #     yield observer_classes
      #   end
      #   self
      # end

      def notify(action)
        changed
        notify_observers action
        self
      end

      def init!
        self.metadata = dictionary_cache_service.dictionary_metadata
        if metadata
          notify :init!
        else
          refresh!
        end
      end

      def metadata=(value)
        dictionary_cache_service.dictionary_metadata_set(value: value)
        @metadata = value
      end
    end
  end
end
