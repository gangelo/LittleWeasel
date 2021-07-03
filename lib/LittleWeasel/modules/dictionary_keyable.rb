# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'dictionary_key_validatable'

module LittleWeasel
  module Modules
    # This module defines attributes and functionality for a dictionary
    # key. A dictionary key is a unique key (basically a locale and optional
    # tag suffix) that is used to link a dictionary to the dictionary cache
    # and dictionary metadata objects.
    module DictionaryKeyable
      include Modules::DictionaryKeyValidatable

      attr_reader :dictionary_key

      delegate :key, to: :dictionary_key

      private

      attr_writer :dictionary_key
    end
  end
end
