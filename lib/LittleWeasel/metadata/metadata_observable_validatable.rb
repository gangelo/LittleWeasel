# frozen_string_literal: true

require_relative 'metadata_observerable'

module LittleWeasel
  module Metadata
    # This module provides methods to validate MetadataObservable objects.
    module MetadataObservableValidatable
      # This method validates a single MetadataObserverable object.
      def validate_metadata_observable(metadata_observable)
        unless valid_metadata_observable? metadata_observable
          raise 'Argument metadata_observable is not a ' \
                "Metadata::MetadataObserverable object: #{metadata_observable.class}"
        end
      end

      def valid_metadata_observable?(metadata_observable)
        metadata_observable.is_a? Metadata::MetadataObserverable
      end
    end
  end
end
