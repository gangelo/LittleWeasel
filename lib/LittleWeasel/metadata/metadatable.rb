# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative '../services/dictionary_cache_service'

module LittleWeasel
  module Metadata
    # This module defines methods to support objects that manage other objects
    # that manage metadata related to a dictionary/ies.
    module Metadatable
      def self.included(base)
        base.extend ClassMethods
      end

      # class method inclusions for convenience.
      module ClassMethods
        # Override this method to return the metadata key associated with this
        # metadata object in the dictionary cache.
        def metadata_key
          to_sym
        end
      end

      def metadata_key
        self.class.metadata_key
      end

      # This method should UNCONDITIONALLY update the local metadata, using the
      # metadata_key and notify all observers (if any) to initialize themselves
      # as well.
      #
      # This method should be chainable (return self).
      #
      # @example
      #
      # . # Example of a root-level dictionary metadata object (e.g.
      # . # Metadata::DictionaryMetadata)
      #   def init(_params: nil)
      #     self.metadata = {}
      #     notify action: :init
      #     refresh_local_metadata
      #     unless count_observers.zero? || metadata.present?
      #       raise 'Observers were called to #init but the dictionary cache metadata was not initialized'
      #     end
      #
      #     self
      #   end
      #
      # . # Example of a metadata observable object (e.g.
      # . # Metadata::InvalidWords::InvalidWordsMetadata)
      #   def init(params: nil)
      #     self.metadata = Services::InvalidWordsService.new(dictionary_words).execute
      #     self
      #   end
      #
      # :reek:UnusedParameters, ignored - This method is meant to be called with the given argument and raises an error if not overridden
      def init(params: nil)
        raise Errors::MustOverrideError
      end

      # This method should refresh the local metadata from the dictionary cache,
      # if metadata exists in the dictionary cache for the given metatata_key.
      # Otherwise, #init should be called to initialize this object.
      # The idea is that metadata should be shared across metadata objects of
      # the same type that use the same metadata_key.
      #
      # This method should be chainable (return self).
      #
      # @example
      #
      #   def refresh(params: nil)
      #     refresh_local_metadata
      #     init unless metadata.present?
      #     self
      #   end
      # :reek:UnusedParameters, ignored - This method is meant to be called with the given argument and raises an error if not overridden
      def refresh(params: nil)
        raise Errors::MustOverrideError
      end

      private

      attr_reader :metadata

      # This method should set the metadata in the dictionary cache, using the
      # appropriate metadata key for this object (or nil if the root metadata
      # object) AND set the @metadata local attribute so that a local copy is
      # available for use.
      #
      # When instantiating this object, #init (see #init comments). If an
      # updated copy of the metadata is needed #refresh (see comments) should
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

      # This method updates the local metadata ONLY. Use this method if you
      # need to update the local metadata from the dictionary cache metadata.
      #
      # Override this method in metadata observable classes as needed.
      def refresh_local_metadata
        @metadata = dictionary_metadata_service.dictionary_metadata
      end

      # This method should update the dictionary metadata for the the object
      # when it is called.
      #
      # @example
      #
      #   def update_dictionary_metadata(value:)
      #     dictionary_cache_service = LittleWeasel::Services::DictionaryCacheService.new(
      #       dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
      #     dictionary_cache_service.dictionary_metadata_set(
      #       metadata_key: metadata_key, value: value)
      #   end
      # :reek:UnusedParameters, ignored - This method is meant to be called with the given argument and raises an error if not overridden
      def update_dictionary_metadata(value:)
        raise Errors::MustOverrideError
      end
    end
  end
end
