# frozen_string_literal: true

require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/dictionary_cache_validatable'
require_relative '../modules/dictionary_keyable'

module LittleWeasel
  module Services
    class DictionaryCacheService
      include Modules::DictionaryKeyable
      include Modules::DictionaryCacheValidatable
      include Modules::DictionaryCacheKeys

      attr_accessor :dictionary_cache

      # This class expects a simple, empty Hash via the dictionary_cache;
      # attribute and produces the following structure depending on what
      # service methods act upon the Hash that is passed.
      #
      # @example This is an example:
      #
      # {
      #   'dictionary_cache' =>
      #   {
      #     'next_dictionary_id' => 0,
      #     'dictionary_references' =>
      #     {
      #       'en' =>
      #       {
      #         'dictionary_id' => 0
      #       },
      #       'en-US' =>
      #       {
      #         'dictionary_id' => 1
      #       }
      #     },
      #     'dictionaries' =>
      #     {
      #       0 =>
      #         {
      #           'file' => '/en.txt',
      #           'dictionary_object' => {}
      #         },
      #       1 =>
      #         {
      #           'file' => '/en-US.txt',
      #           'dictionary_object' => {}
      #         }
      #     }
      #   }
      # }
      def initialize(dictionary_key:, dictionary_cache:)
        validate_dictionary_key dictionary_key: dictionary_key
        self.dictionary_key = dictionary_key

        validate_dictionary_cache dictionary_cache: dictionary_cache
        self.dictionary_cache = dictionary_cache

        self.class.reset!(dictionary_cache: dictionary_cache) unless dictionary_cache[DICTIONARY_CACHE]
      end

      class << self
        # This method resets dictionary_cache to its initialized state - all
        # data is lost.
        def reset!(dictionary_cache:)
          Modules::DictionaryCacheKeys.initialize_dictionary_cache dictionary_cache: dictionary_cache
        end
        alias init! reset!
        alias initialize! reset!

        # Returns the number of dictionaries. This count
        # has nothing to do with whether or not the dictionaries
        # are loaded, only the number of dictionary referenced
        # in the cache.
        def count(dictionary_cache:)
          dictionary_cache.dig(self::DICTIONARY_CACHE, self::DICTIONARIES)&.keys&.count || 0
        end

        # Returns true if the dictionary cache is initialized; that
        # is, if it's in the same state the dictionary cache would
        # be in after #reset! is called.
        def init?(dictionary_cache:)
          initialized_dictionary_cache = reset!({})
          dictionary_cache.eql?(initialized_dictionary_cache)
        end
        alias initialized? init?

        # Returns true if the dictionary cache has, at a minimum, dictionary
        # references added to it.
        def populated?(dictionary_cache:)
          count(dictionary_cache: dictionary_cache).positive?
        end
      end

      # This method resets the dictionary cache for the given key.
      def reset!
        # TODO: Do not delete the dictionary if it is being pointed to by
        # another dictionary reference.
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES]&.delete(dictionary_id)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARY_REFERENCES]&.delete(key)
        self
      end
      alias init! reset!

      # Returns true if the dictionary reference exists for the given key. This
      # method is only concerned with the dictionary reference only and has
      # nothing to do with whether or not the associated dictionary is actually
      # loaded or not; for this, use #loaded?
      def dictionary_reference?
        dictionary_reference&.present? || false
      end

      # Returns true if the dictionary exists for the given dictionary id
      # associated with the given key.
      def dictionary?
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES].key? dictionary_id
      end

      # Returns true if a dictionary reference can be added. false is
      # returned if a dictionary reference already exists.
      def add_dictionary_reference?
        !dictionary_reference?
      end

      def add_dictionary_reference(file:)
        raise ArgumentError, "Dictionary reference for key '#{key}' already exists." unless add_dictionary_reference?

        dictionary_id = dictionary_id_for(file: file)
        dictionary_reference_reset dictionary_id: dictionary_id
        # Only reset the dictionary if it doesn't already exist;
        # dictionaries can have more than one reference and we don't
        # want to blow away the dictionary object, metadata, or any
        # other data associated with it if it already exists.
        dictionary_reset(file: file) unless dictionary?
        self
      end

      # Returns true if a dictionary id can be found in the dictionary
      # references for the given key.
      def dictionary_id
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARY_REFERENCES, key, DICTIONARY_ID)
      end

      # Returns true if a dictionary id can be found in the dictionary
      # references for the given key. This method raises an error if the
      # file key cannot be found.
      def dictionary_id!
        return dictionary_id if dictionary_id?

        raise ArgumentError, "A dictionary id could not be found for key '#{key}'."
      end

      def dictionary_file!
        raise ArgumentError, "A dictionary reference could not be found for key '#{key}'." unless dictionary_reference?

        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][FILE]
      end

      def dictionary_loaded?
        # TODO: NOW: Remove this?
        # unless dictionary_reference?
        #  raise ArgumentError, "Argument key '#{key}' does not exist; use #add_dictionary_reference to add it first."
        # end

        dictionary_object?
      end
      alias dictionary_cached? dictionary_loaded?

      def dictionary_object?
        dictionary_object.present?
      end

      # Returns the dictionary object from the dictionary cache for the given
      # key. This method raises an error if the dictionary is not in the cache;
      # that is, if the dictionary was not previously loaded.
      def dictionary_object!
        unless dictionary_object?
          raise ArgumentError,
            "The dictionary associated with argument key '#{key}' is not in the cache; load it from disk first."
        end

        dictionary_object
      end

      def dictionary_object
        return unless dictionary_reference?

        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id!, DICTIONARY_OBJECT)
      end

      def dictionary_object=(object)
        raise ArgumentError, 'Argument object is not a Dictionary object' unless object.is_a? Dictionary

        unless dictionary_reference?
          raise ArgumentError,
            "The dictionary reference associated with key '#{key}' could not be found."
        end
        return if object.equal? dictionary_object

        if dictionary_loaded?
          raise ArgumentError,
            "The dictionary is already loaded/cached for key '#{key}'; use #unload or #kill first."
        end

        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][DICTIONARY_OBJECT] = object
      end

      private

      def dictionary_reference
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARY_REFERENCES, key)
      end

      def dictionary_reference_reset(dictionary_id:)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARY_REFERENCES][key] = {
          DICTIONARY_ID => dictionary_id
        }
      end

      # Returns the dictionary_id for file if it exists in dictionaries;
      # otherwise, returns the next dictionary id that should be used.
      def dictionary_id_for(file:)
        dictionaries = dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES)
        dictionaries&.each_pair do |dictionary_id, dictionary_hash|
          return dictionary_id if file == dictionary_hash[FILE]
        end
        next_dictionary_id
      end

      def next_dictionary_id
        (dictionary_cache[DICTIONARY_CACHE][NEXT_DICTIONARY_ID] += 1) - 1
      end

      def dictionary_id?
        dictionary_id.present?
      end

      def dictionary_reset(file:)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!] = {
          FILE => file,
          DICTIONARY_OBJECT => {}
        }
      end
    end
  end
end
