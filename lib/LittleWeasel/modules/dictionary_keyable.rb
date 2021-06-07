# frozen_string_literal: true

require_relative 'dictionary_key_validatable'

module LittleWeasel
  module Modules
    module DictionaryKeyable
      include Modules::DictionaryKeyValidatable

      delegate :key, to: :dictionary_key

      private

      attr_accessor :dictionary_key
    end
  end
end
