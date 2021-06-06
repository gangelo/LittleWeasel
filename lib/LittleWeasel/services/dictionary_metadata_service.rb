# frozen_string_literal: true

require_relative '../modules/dictionary_metadata_keys'
require_relative '../modules/dictionary_metadata_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_metadata_validatable'

module LittleWeasel
  module Services
    class DictionaryMetadataService
      include Modules::DictionaryKeyable
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryCacheKeys
      include Modules::DictionaryMetadataValidatable

      # @example metadata Hash structure:
      #
      #   {
      #     '<dictionary_id>' =>
      #       {
      #         '<metadata_key>' => <metadata_object>
      #       },
      #       ...
      #     }
      #   }
      def initialize(dictionary_key:, dictionary_metadata:, dictionary_cache:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache

        self.dictionary_metadata = dictionary_metadata
        validate_dictionary_metadata
      end

      class << self
        # This method initializes the dictionary_metadata object to its
        # initialized state - all data is lost, but the object reference is
        # maintained.
        def init!(dictionary_metadata:)
          dictionary_metadata.each_key { |key| dictionary_metadata.delete(key) }
          dictionary_metadata
        end
        alias initialize! init!

        # Returns true if the dictionary metadata is initialized; that is, if
        # it's in the same state the dictionary metadata would be in if #init!
        # were called.
        def init?(dictionary_metadata:)
          initialized_dictionary_metadata = init!({})
          dictionary_metadata.eql?(initialized_dictionary_metadata)
        end
        alias initialized? init?
      end

      # This method resets the dictionary metadata associated with the dictionary
      # associated with the dictionary key.
      def init!
        dictionary_metadata&.delete(dictionary_id)
        self
      end

      # This method will return true if metadata exists for the dictionary
      # associated with the given dictionary key, for the given metadata key.
      def dictionary_metadata?(metadata_key:)
        dictionary_metadata(metadata_key: metadata_key)&.present? || false
      end

      def dictionary_metadata(metadata_key:)
        dictionary_metadata.dig(dictionary_id!, metadata_key)
      end

      def dictionary_metadata_set(value:, metadata_key:)
        dictionary_metadata[dictionary_id!][metadata_key] = value
        self
      end

      private

      attr_writer :dictionary_metadata, :dictionary_key, :dictionary_metadata

      def dictionary_id
        dictionary_metadata_service.dictionary_id
      end

      def dictionary_id!
        dictionary_metadata_service.dictionary_id!
      end
    end
  end
end
