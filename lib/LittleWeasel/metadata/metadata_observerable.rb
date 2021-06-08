# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative 'metadatable'

module LittleWeasel
  module Metadata
    # Defines methods to support dictionary metadata
    module MetadataObserverable
      include Metadatable

      def self.included(base)
        base.extend ClassMethods
      end

      # class method inclusions for convenience.
      module ClassMethods
        # If the medatata observer is not in a state to observe, or is turned
        # "off", return false; otherwise, return true...
        #
        # Configuration option settings may turn a metadata observer "off";
        # for example, InvalidWordsMedata will not be observable unless
        # LittleWeasel.configuration.max_invalid_words_bytesize? returns true.
        #
        # Other variables may also determine whether or not a metadata object is
        # capable of observing; consequently, an instance-level #observe? method
        # is also availble if this is the case (see below).
        #
        # If the observable state of your metadata object depends on
        # configuration settings ALONE, return true/false using this class-level
        # method, and do not override the instance-level #observe? method.
        #
        # If the observable state of your metadata object can only be determined
        # AFTER the metadata object is instantiated: return true from the the
        # class-level .observe? method; then, override the instance-level
        # #observe? method and return true/false accordingly.
        #
        # If the observable state of your metadata object is determined by BOTH
        # configuration settings AND variables that can only be determined AFTER
        # the metadata object has been instantiated, use both the class-level
        # and instance-level observe? to return true/false accordingly.
        def observe?
          false
        end
      end

      # Return true/false depending on whether or not this metadata observer
      # is in a state to observe.
      #
      # (See .observe? class-level method comments)
      def observe?
        self.class.observe?
      end

      # This is an override of Metadata#refresh_local_metadata. See
      # Metadata#refresh_local_metadata comments.
      def refresh_local_metadata
        @metadata = dictionary_metadata_service.get_dictionary_metadata(metadata_key: metadata_key)
      end

      # This method receives notifications from an observable.
      # object and should be chainable (return self).
      # All actions should be filtered through the
      # actions_whitelist and an error raised if action
      # is not in the actions_whitelist. If **args are used,
      # further filtering should be applied based on the
      # need.
      #
      # @example
      #
      #  def update(action, **args)
      #    raise ArgumentError unless actions_whitelist.include? action
      #
      #    send(action)
      #    self
      #  end
      def update(_action, **_args)
        raise Errors::MustOverrideError
      end

      # This method should return actions (messages) that can be sent
      # to this object; for example, at a minimum :init and :refresh
      # need to be in this list
      def actions_whitelist
        %i[init refresh]
      end
    end
  end
end
