# frozen_string_literal: true

require_relative '../modules/dictionary_cache_servicable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_metadata_validatable'

module LittleWeasel
  module Services
    # This class provides methods for managing and manipulating the
    # dictionary metadata cache associated with the given dictionary,
    # (dictionary_key) for the supplied metadata_key.
    class DictionaryMetadataService
      include Modules::DictionaryKeyable
      include Modules::DictionaryCacheServicable
      include Modules::DictionaryMetadataValidatable

      attr_reader :dictionary_metadata

      # @example metadata Hash structure:
      #
      #   {
      #     <dictionary_id!> =>
      #       {
      #         :<metadata_key> => <metadata_object>
      #       },
      #       ...
      #     }
      #   }
      def initialize(dictionary_key:, dictionary_cache:, dictionary_metadata:)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache

        validate_dictionary_metadata dictionary_metadata: dictionary_metadata
        self.dictionary_metadata = dictionary_metadata
      end

      class << self
        # This method initializes the dictionary_metadata object to its
        # initialized state - all data is lost, but the object reference is
        # maintained.
        def init(dictionary_metadata:)
          Modules::DictionaryMetadataValidatable.validate dictionary_metadata: dictionary_metadata

          dictionary_metadata.each_key { |key| dictionary_metadata.delete(key) }
          dictionary_metadata
        end

        # Returns true if the dictionary metadata is initialized; that is, if
        # it's in the same state the dictionary metadata would be in if #init!
        # were called.
        def init?(dictionary_metadata:)
          Modules::DictionaryMetadataValidatable.validate dictionary_metadata: dictionary_metadata

          initialized_dictionary_metadata = init(dictionary_metadata: {})
          dictionary_metadata.eql?(initialized_dictionary_metadata)
        end
        alias initialized? init?
      end

      # This method initializes the dictionary metadata for dictionary metadata
      # associated with the dictionary_id! and metadata_key.
      def init(metadata_key:)
        metadata = dictionary_metadata[dictionary_id!]
        metadata&.delete(metadata_key)
        metadata = dictionary_metadata_init_if
        metadata[metadata_key] = nil
        self
      end

      # This method will return true if metadata exists for the dictionary
      # associated with the given dictionary key, for the given metadata key.
      def dictionary_metadata?(metadata_key:)
        dictionary_metadata.dig(dictionary_id, metadata_key)&.present? || false
      end

      def get_dictionary_metadata(metadata_key:)
        dictionary_metadata.dig(dictionary_id!, metadata_key)
      end

      def set_dictionary_metadata(value:, metadata_key:)
        dictionary_metadata[dictionary_id!][metadata_key] = value
        self
      end

      private

      attr_writer :dictionary_metadata

      def dictionary_metadata_init_needed?
        dictionary_metadata[dictionary_id!].blank?
      end

      # This method initializes the metadata for the
      # dictionary_id! if it is not already initialized.
      # The metadata for the given dictionary_id! is returned.
      def dictionary_metadata_init_if
        metadata = dictionary_metadata[dictionary_id!]
        return metadata unless dictionary_metadata_init_needed?

        metadata = {}
        dictionary_metadata[dictionary_id!] = {}
      end

      def dictionary_id
        dictionary_cache_service.dictionary_id
      end

      def dictionary_id!
        dictionary_cache_service.dictionary_id!
      end
    end
  end
end
