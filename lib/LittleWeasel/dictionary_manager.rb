# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'singleton'
require_relative 'modules/deep_dup'
require_relative 'modules/dictionary_loader'
require_relative 'modules/hash_keys'

module LittleWeasel
  # This class manages the dictionaries available to the word checking
  # processes.
  class DictionaryManager
    include Singleton
    include Modules::DeepDup
    include Modules::DictionaryLoader
    include Modules::HashKeys

    delegate :dictionary_count, :to_array, :to_hash, to: :dictionaries_hash

    def initialize
      reset
    end

    # Adds dictionary to the dictionary_hash, but does not load it.
    def <<(dictionary)
      return unless dictionary.is_a? Dictionaries::Dictionary

      dictionary = dictionary&.to_hash
      dictionaries_hash.merge!(dictionary).deep_dup if dictionary

      # TODO: Return dictionary?
    end

    # Resets the dictionaries by removing all of them from the
    # internal dictionaries_hash.
    def reset
      self.dictionaries_hash = DictionariesHash.new
    end

    private

    attr_accessor :dictionaries_hash
  end
end
