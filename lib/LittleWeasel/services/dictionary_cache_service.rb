# frozen_string_literal: true

require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/dictionary_cache_validatable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_sourceable'

module LittleWeasel
  module Services
    # This class provides methods and attributes that can be used to manage the
    # dictionary cache. The "dictionary cache" is a simple Hash that provides
    # access to informaiton related to dictionaries through a dictionary "key".
    # A dictionary "key" is a unique key comprised of a locale and
    # optional "tag" (see Modules::Taggable and DictionaryKey for more
    # information). The dictionary cache also provides a way for dictionary
    # objects to share dictionary information, in particular, the dictionary
    # file and dictionary metadata.
    class DictionaryCacheService
      include Modules::DictionaryKeyable
      include Modules::DictionaryCacheValidatable
      include Modules::DictionaryCacheKeys
      include Modules::DictionarySourceable

      attr_reader :dictionary_cache

      # This class produces the following (example) Hash that represents the
      # dictionary cache structure:
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
      #       },
      #       'en-US-temp' =>
      #       {
      #         'dictionary_id' => 2
      #       }
      #     },
      #     'dictionaries' =>
      #     {
      #       0 =>
      #         {
      #           'source' => '/en.txt',
      #           'dictionary_object' => {}
      #         },
      #       1 =>
      #         {
      #           'source' => '/en-US.txt',
      #           'dictionary_object' => {}
      #         },
      #       2 =>
      #         {
      #           'source' => 'memory',
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

        self.class.init(dictionary_cache: dictionary_cache) unless dictionary_cache[DICTIONARY_CACHE]
      end

      class << self
        # This method resets dictionary_cache to its initialized state - all
        # data is lost.
        def init(dictionary_cache:)
          Modules::DictionaryCacheKeys.initialize_dictionary_cache dictionary_cache: dictionary_cache
        end

        # Returns true if the dictionary cache is initialized; that
        # is, if it's in the same state the dictionary cache would
        # be in after #init is called.
        def init?(dictionary_cache:)
          initialized_dictionary_cache = init(dictionary_cache: {})
          dictionary_cache.eql?(initialized_dictionary_cache)
        end

        # Returns the number of dictionaries. This count
        # has nothing to do with whether or not the dictionaries
        # are loaded, only the number of dictionary referenced
        # in the cache.
        def count(dictionary_cache:)
          dictionary_cache.dig(self::DICTIONARY_CACHE, self::DICTIONARIES)&.keys&.count || 0
        end

        # Returns true if the dictionary cache has, at a minimum, dictionary
        # references added to it.
        def populated?(dictionary_cache:)
          count(dictionary_cache: dictionary_cache).positive?
        end
      end

      # This method resets the dictionary cache for the given key.
      def init
        # TODO: Do not delete the dictionary if it is being pointed to by
        # another dictionary reference.
        dictionary_cache_hash = dictionary_cache[DICTIONARY_CACHE]
        dictionary_cache_hash[DICTIONARIES]&.delete(dictionary_id)
        dictionary_cache_hash[DICTIONARY_REFERENCES]&.delete(key)
        self
      end

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

      # Adds a dictionary file source. A "file source" is a file path that
      # indicates that the dictionary words associated with this dictionary are
      # located on disk. This file path is used to locate and load the
      # dictionary words into the dictionary cache for use.
      #
      # @param file [String] a file path pointing to the dictionary file to load and use.
      #
      # @return returns a reference to self.
      def add_dictionary_file_source(file:)
        add_dictionary_source(source: file)
      end

      # Adds a dictionary memory source. A "memory source" indicates that the
      # dictionary words associated with this dictionary were created
      # dynamically and will be located in memory, as opposed to loaded from
      # a file on disk.
      #
      # @return returns a reference to self.
      def add_dictionary_memory_source
        add_dictionary_source(source: memory_source)
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

        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][SOURCE]
      end

      def dictionary_file
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id, SOURCE)
      end
      alias dictionary_source dictionary_file

      # This method returns true if the dictionary associated with the
      # given dictionary key is loaded/cached. If this is the case,
      # a dictionary object is available in the dictionary cache.
      def dictionary_object?
        dictionary_object.present?
      end
      alias dictionary_loaded? dictionary_object?

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

      def unload_dictionary
        unless dictionary_reference?
          raise ArgumentError,
            "The dictionary reference associated with key '#{key}' could not be found."
        end

        unless dictionary_loaded?
          raise ArgumentError,
            "The dictionary associated with key '#{key}' is not loaded/cached."
        end

        dictionary_object = self.dictionary_object
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][DICTIONARY_OBJECT] = nil
        dictionary_object
      end

      private

      attr_writer :dictionary_cache

      # Adds a dictionary source (file or memory).
      #
      # @param source [String] the dictionary source. This can be a file path
      # or the key word 'memory' to indicate the dictionary was created
      # dynamically from memory.
      def add_dictionary_source(source:)
        raise ArgumentError, "Dictionary reference for key '#{key}' already exists." unless add_dictionary_reference?

        dictionary_id = dictionary_id_for(source: source)
        dictionary_reference_reset dictionary_id: dictionary_id
        # Only reset the dictionary if it doesn't already exist; dictionaries
        # can have more than one reference and we don't want to blow away the
        # dictionary object, metadata, or any other data associated with it if
        # it already exists.
        dictionary_reset(source: source) unless dictionary?
        self
      end

      def dictionary_reference
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARY_REFERENCES, key)
      end

      def dictionary_reference_reset(dictionary_id:)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARY_REFERENCES][key] = {
          DICTIONARY_ID => dictionary_id
        }
      end

      # Returns the dictionary_id for the source if it exists in dictionaries;
      # otherwise, returns the next dictionary id that should be used.
      def dictionary_id_for(source:)
        dictionaries = dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES)
        dictionaries&.each_pair do |dictionary_id, dictionary_hash|
          return dictionary_id if source == dictionary_hash[SOURCE]
        end
        next_dictionary_id
      end

      def next_dictionary_id
        (dictionary_cache[DICTIONARY_CACHE][NEXT_DICTIONARY_ID] += 1) - 1
      end

      def dictionary_id?
        dictionary_id.present?
      end

      def dictionary_reset(source:)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!] = {
          SOURCE => source,
          DICTIONARY_OBJECT => {}
        }
      end
    end
  end
end
