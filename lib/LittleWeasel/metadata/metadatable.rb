# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative '../services/dictionary_cache_service'

module LittleWeasel
  module Metadata
    # Defines methods to support dictionary metadata
    module Metadatable
      def self.included(base)
        base.extend MetadatableClassMethods
      end

      module MetadatableClassMethods
        # Override this method to return the metadata key associated with this
        # metadata object in the dictionary cache.
        def metadata_key
          to_sym
        end
      end

      def metadata_key
        self.class.metadata_key
      end

      # This method should initialize the metadata if metadata currently
      # exists for this object or call #refresh! in the case metadaa
      # DOES NOT currently exist for this object. The idea is that metadata
      # should be able to be shared across metadata objects of the same
      # type. This method should be chainable (return self).
      #
      # @example
      #
      #   def init!(_parms: nil)
      #     self.metadata = dictionary_cache_service.dictionary_metadata(
      #       metadata_key: <metadata_hash_key>)
      #     refresh! unless metadata
      #     self
      #   end
      # rubocop: disable Lint/UnusedMethodArgument
      def init!(params: nil)
        raise Errors::MustOverrideError
      end
      # rubocop: enable Lint/UnusedMethodArgument

      # This method should UNconditionally update the metadata and be
      # chainable (return self).
      #
      # @example
      #
      #   def refresh!(_params: nil)
      #     self.metadata = Services::InvalidWordsMetadataService.new(dictionary).execute
      #     self
      #   end
      # rubocop: disable Lint/UnusedMethodArgument
      def refresh!(params: nil)
        raise Errors::MustOverrideError
      end
      # rubocop: enable Lint/UnusedMethodArgument

      private

      attr_reader :metadata

      # This method should set the metadata in the dictionary cache, using the
      # appropriate metadata key for this object (or nil if the root metadata
      # object) AND set the @metadata local attribute so that a local copy is
      # available for use.
      #
      # When instantiating this object, #init! (see #init! comments). If an
      # updated copy of the metadata is needed #refresh! (see comments) should
      # be called.
      #
      # @example
      #
      #   def metadata=(value)
      #     dictionary_cache_service = LittleWeasel::Services::DictionaryCacheService.new(
      #       dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
      #     dictionary_cache_service.dictionary_metadata_set(
      #       metadata_key: METADATA_KEY, value: value)
      #     @metadata = value
      #   end
      def metadata=(value)
        @metadata = value
        update_dictionary_metadata value: value
      end

      # This method should update the dictionary metadata for the the object
      # when it is called.
      #
      # @example
      #
      #   def update_dictionary_metadata(value:)
      #     dictionary_cache_service = LittleWeasel::Services::DictionaryCacheService.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
      #     dictionary_cache_service.dictionary_metadata_set(metadata_key: metadata_key, value: value)
      #   end
      # rubocop: disable Lint/UnusedMethodArgument
      def update_dictionary_metadata(value:)
        raise Errors::MustOverrideError
      end
      # rubocop: enable Lint/UnusedMethodArgument
    end
  end
end
