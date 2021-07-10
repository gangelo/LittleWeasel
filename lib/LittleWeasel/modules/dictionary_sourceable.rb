# frozen_string_literal: true

require 'securerandom'
require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/dictionary_source_validatable'
require_relative '../modules/dictionary_validatable'

module LittleWeasel
  module Modules
    # This module provides methods to manage dictionary sources.
    module DictionarySourceable
      include Modules::DictionaryCacheKeys
      include Modules::DictionarySourceValidatable
      include Modules::DictionaryValidatable

      MEMORY_SOURCE = '*'

      def self.file_source?(dictionary_source)
        !memory_source? dictionary_source
      end

      def self.memory_source?(dictionary_source)
        dictionary_source =~ /^#{Regexp.quote(MEMORY_SOURCE)}[0-9a-fA-F]{8}$/
      end

      def memory_source
        "#{MEMORY_SOURCE}#{SecureRandom.uuid[0..7]}"
      end
      module_function :memory_source

      # Adds a dictionary source. A "dictionary source" specifies the source from which
      # the dictionary ultimately obtains its words.
      #
      # @param source [String] the dictionary source. This can be a file path
      # or a memory source indicator to signify that the dictionary was created
      # dynamically from memory.
      def add_dictionary_source(dictionary_source:)
        validate_dictionary_source_does_not_exist dictionary_cache_service: self

        set_dictionary_reference \
          dictionary_id: dictionary_id_associated_with(dictionary_source: dictionary_source)
        # Only set the dictionary source if it doesn't already exist because settings
        # the dictionary source wipes out the #dictionary_object; dictionary objects
        # can have more than one dictionary reference pointing to them, and we don't
        # want to blow away the #dictionary_object, metadata, or any other data
        # associated with it if it already exists.
        set_dictionary_source(dictionary_source: dictionary_source) unless dictionary?
        self
      end

      def dictionary_source
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id, SOURCE)
      end
      alias dictionary_file dictionary_source

      def dictionary_source!
        raise ArgumentError, "A dictionary source could not be found for key '#{key}'." \
          unless dictionary_reference?

        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][SOURCE]
      end
      alias dictionary_file! dictionary_source!

      private

      # Sets the dictionary source in the dictionary cache.
      def set_dictionary_source(dictionary_source:)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!] = {
          SOURCE => dictionary_source,
          DICTIONARY_OBJECT => {}
        }
      end

      # Returns the dictionary_id for the dictionary_source if it exists in
      # dictionaries; otherwise, returns the new dictionary id that should
      # be used.
      def dictionary_id_associated_with(dictionary_source:)
        dictionaries = dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES)
        dictionaries&.each_pair do |dictionary_id, dictionary_hash|
          return dictionary_id if dictionary_source == dictionary_hash[SOURCE]
        end
        SecureRandom.uuid[0..7]
      end
    end
  end
end
