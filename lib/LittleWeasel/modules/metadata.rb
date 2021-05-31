# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative '../services/dictionary_cache_service'

module LittleWeasel
  module Modules
    # Defines methods to support dictionary metadata
    module Metadata
      def self.included(base)
        base.extend MetadataClassMethods
      end

      module MetadataClassMethods
        # Override this method to return the metadata key associated with this
        # metadata object in the dictionary cache. The root-level metadata
        # object should not override this method (return nil).
        def metadata_key; end
      end

      def metadata_key
        self.class.metadata_key
      end

      # This method should UNconditionally update the metadata and be
      # chainable (return self).
      #
      # @example
      #
      #   def refresh!(params: nil)
      #     self.metadata = Services::MaxInvalidWordsByteSizeService.new(dictionary).execute
      #     self
      #   end
      def refresh!(params: nil)
        raise Errors::MustOverrideError
      end

      private

      attr_reader :metadata

      # This method should initialize the metadata if metadata currently
      # exists for this object or call #refresh! in the case metadaa
      # DOES NOT currently exist for this object. The idea is that metadata
      # should be able to be shared across metadata objects of the same
      # type. This method should be chainable (return self).
      #
      # @example
      #
      #   def init!(parms: nil)
      #     self.metadata = dictionary_cache_service.dictionary_metadata(metadata_key: <metadata_hash_key>)
      #     refresh! unless metadata
      #     self
      #   end
      def init!(params: nil)
        raise Errors::MustOverrideError
      end

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
      #  def metadata=(value)
      #    dictionary_cache_service.dictionary_metadata_set(metadata_key: METADATA_KEY, value: value)
      #    @metadata = value
      #  end
      def metadata=(value)
        dictionary_cache_service = Services::DictionaryCacheService.new(dictionary_key: dictionary_key,
                                                                        dictionary_cache: dictionary_cache)
        dictionary_cache_service.dictionary_metadata_set(metadata_key: self.class.metadata_key, value: value)
        @metadata = value
      end
    end
  end
end
