# frozen_string_literal: true

require_relative '../modules/metadata'
require_relative '../services/max_invalid_words_bytesize_service'

module LittleWeasel
  module Metadata
    class MaxInvalidWordsBytesizeMetadata
      include Modules::Metadata

      METADATA_KEY = :'$$max_invalid_words_bytesize$$'

      delegate :on?, :off?, :value, :value_exceeded?,
        :current_invalid_word_bytesize, :cache_invalid_words?,
        to: :max_invalid_words_bytesize_service_results

      delegate :dictionary, to: :dictionary_metadata, allow_nil: true

      attr_reader :dictionary_metadata

      def initialize(dictionary_metadata)
        raise ArgumentError unless dictionary_metadata.is_a? Observable

        dictionary_metadata.add_observer self
        self.dictionary_metadata = dictionary_metadata

        metadata = dictionary.dig(root_metadata_key, METADATA_KEY)
        if metadata
          results = metadata.send(:max_invalid_words_bytesize_service_results)
          init_if(with: results) and return if results
        end
        init!
      end

      def refresh!
        init!
      end

      def to_hash(include_root: false)
        metadata = { METADATA_KEY => self }
        return { root_metadata_key => metadata } if include_root
        metadata
      end

      def update(action)
        actions_whitelist = %i[init init! refresh! to_hash]
        raise ArgumentError unless actions_whitelist.include? action

        public_send action
      end

      private

      attr_accessor :max_invalid_words_bytesize_service_results
      attr_writer :dictionary_metadata

      def init!
        init_data with: Services::MaxInvalidWordsByteSizeService.new(dictionary).execute
        self
      end

      def init_data(with:, **args)
        dictionary[root_metadata_key][METADATA_KEY] = self
        self.max_invalid_words_bytesize_service_results = with
      end

      def init_needed?
        !dictionary.dig(root_metadata_key, METADATA_KEY).present?
        !max_invalid_words_bytesize_service_results.present?
      end

      def root_metadata_key
        dictionary_metadata.class::METADATA_KEY
      end
    end
  end
end
