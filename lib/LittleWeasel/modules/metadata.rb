# frozen_string_literal: true

require_relative '../errors/must_override_error'

module LittleWeasel
  module Modules
    # Defines methods to support Dictionary metadata
    module Metadata
      # TODO: Should we allow :[]=?
      delegate :[], :[]=, to: :dictionary

      def refresh!
        raise Errors::MustOverrideError
      end

      def to_hash(include_root: false)
        raise Errors::MustOverrideError
      end

      # Receives notifications from the observer
      # when appropriate.
      def update(_action)
        raise Errors::MustOverrideError
      end

      private

      attr_accessor :dictionary_words_hash

      def init
        raise Errors::MustOverrideError
      end

      def init!
        raise Errors::MustOverrideError
      end

      def init_if(with:, **args)
        # DO NOT overwrite the initialization data by default.
        # By deault, this method should only update the initialization
        # data if init_needed? returns true.
        init_data(with: with, **args) if init_needed?
      end

      # Override this method to set your specific initialization
      # data attributes; that is, whatever data attributes
      # the including class needs to be considered initialized.
      def init_data(with:, **_args)
        raise Errors::MustOverrideError
      end

      # Should return true if this object's current
      # initialization data state is considered to be
      # uninitialized.
      def init_needed?
        raise Errors::MustOverrideError
      end
    end
  end
end
