# frozen_string_literal: true

require_relative '../modules/klass_name_to_sym'
require_relative '../modules/max_invalid_words_bytesize_cacheable'
require_relative '../modules/metadata_observer'
require_relative '../services/dictionary_service'
require_relative '../services/max_invalid_words_bytesize_service'

module LittleWeasel
  module Metadata
    class MaxInvalidWordsBytesizeMetadata < Services::DictionaryService
      include Modules::KlassNameToSym
      include Modules::MetadataObserver

      delegate :on?, :off?, :value, :value_exceeded?,
        :current_invalid_word_bytesize, :cache_invalid_words?,
        to: :metadata

      attr_reader :dictionary_metadata

      def initialize(dictionary_metadata:, dictionary:, dictionary_key:, dictionary_cache:)
        super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

        raise ArgumentError, "Argument dictionary_metadata is not an Observable: #{dictionary_metadata.class}." unless dictionary_metadata.is_a? Observable
        raise ArgumentError, "Argument dictionary is not a Hash: #{dictionary.class}." unless dictionary.is_a? Hash

        dictionary_metadata.add_observer self
        self.dictionary_metadata = dictionary_metadata

        # TODO: Should we be doing this here?
        self.extend(Modules::MaxInvalidWordsByteSizeCacheable)
        self.dictionary = dictionary
      end

      class << self
        def metadata_key
          to_sym
        end
      end

      def refresh!(params: nil)
        self.metadata = Services::MaxInvalidWordsByteSizeService.new(dictionary).execute
        self
      end

      def search(params)
        binding.pry
        word = params[:word]
      end

      def update(action, params)
        raise ArgumentError, "Argument action is not in the actions_whitelist: #{action}" unless actions_whitelist.include? action
binding.pry

        send(action, params: params)
        self
      end

      def actions_whitelist
        %i[init! refresh! search]
      end

      private

      attr_accessor :dictionary
      attr_writer :dictionary_metadata

      def init!(params: nil)
        self.metadata = dictionary_cache_service.dictionary_metadata(metadata_key: self.class.metadata_key)
        refresh! unless metadata
        self
      end
    end
  end
end
