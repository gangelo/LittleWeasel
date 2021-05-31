# frozen_string_literal: true

require_relative '../errors/must_override_error'
require_relative 'metadata'

module LittleWeasel
  module Modules
    # Defines methods to support dictionary metadata
    module MetadataObserver
      include Metadata

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
      def update(_action, **args)
        raise Errors::MustOverrideError
      end

      # This method should return actions (messages) that can be sent
      # to this object; for example, at a minimum :init! and :refresh!
      # need to be in this list
      def actions_whitelist
        %i[init! refresh!]
      end
    end
  end
end
