# frozen_string_literal: true

require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/dictionary_cache_validate'
require_relative '../modules/dictionary_key_validate'

module LittleWeasel
  module Services
    # This class provides services that act upon a given dictionary cache. It is
    # important that this class maintain object reference integrity of the
    # dictionary cache object it is manipulating; this also holds true for any
    # additional objects within the dictionary cache object hierarchy. The only
    # exception to this rule applies to object references within the dictionary
    # cache hierarchy, but not the dictionary cache object itself.
    #
    # For example...
    #
    # Destructive methods (reset!, init!, kill!, etc.) should be assumed to
    # alter the object references of any or all # objects within the dictionary
    # cache hierarchy, but NOT the object reference of the dictionary cache
    # object itself (i.e. #dictionary_cache).
    #
    # Consequently, you shouldn't maintain a cached reference to any object
    # other than the #dictionary_cache object itself; this is because these
    # object references will not maintain object reference integrity across
    # calls to destructive dictionary cache service methods.
    class DictionaryCacheService
      include Modules::DictionaryCacheKeys
      include Modules::DictionaryCacheValidate
      include Modules::DictionaryKeyValidate

      delegate :key, to: :dictionary_key

      attr_reader :dictionary_cache, :dictionary_key

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
      #           'dictionary_object' => {},
      #           'dictionary_metadata' => {}
      #         },
      #       1 =>
      #         {
      #           'file' => '/en-US.txt',
      #           'dictionary_object' => {},
      #           'dictionary_metadata' => {}
      #         }
      #     }
      #   }
      # }
      #
      # @example To initialize a dictionary cache:
      #
      def initialize(dictionary_key:, dictionary_cache:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.class.reset!(dictionary_cache: dictionary_cache) unless dictionary_cache[DICTIONARY_CACHE]
        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache
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
        dictionary_reference_reset file: file, dictionary_id: dictionary_id
        # Only reset the dictionary if it doesn't already exist;
        # dictionaries can have more than one reference and we don't
        # want to blow away the dictionary object, metadata, or any
        # other data associated with it if it already exists.
        dictionary_reset(file: file) unless dictionary?
        self
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
        unless dictionary_reference?
          raise ArgumentError, "Argument key '#{key}' does not exist; use #add_dictionary_reference to add it first."
        end

        dictionary_object?
      end
      alias dictionary_cached? dictionary_loaded?

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

        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id!, DICTIONARY_OBJECT).tap do |object|
          return nil if object == {}
        end
      end

      def dictionary_object=(object)
        raise ArgumentError, 'Argument object is not a Dictionary object' unless object.is_a? Dictionary

        unless dictionary_reference?
          raise ArgumentError,
            "The dictionary reference associated with key '#{key}' could not be found."
        end
        return self if object.equal? dictionary_object

        if dictionary_loaded?
          raise ArgumentError,
            "The dictionary is already loaded/cached for key '#{key}'; use #unload or #kill first."
        end

        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][DICTIONARY_OBJECT] = object
      end

      # Initializes the dictionary metadata associated with the given key.
      # No initialization takes place if the metadata already exists.
      def dictionary_metadata_init(with:)
        return if dictionary_metadata?

        dictionary_metadata_reset with: with
      end

      # This method will return true if the metadata for the dictionary associated
      # with the given key has meaningful data; that is, the metadata is #present?
      # not just an empty Hash or nil.
      def dictionary_metadata?(metadata_key: nil)
        metadata = dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id, DICTIONARY_METADATA)
        return false unless metadata&.present?

        return metadata[metadata_key]&.present? if metadata_key

        metadata&.present?
      end

      def dictionary_metadata(metadata_key: nil)
        return unless dictionary_metadata?(metadata_key: metadata_key)

        metadata = dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id!, DICTIONARY_METADATA)

        return metadata[metadata_key] if metadata_key

        metadata
      end

      # def dictionary_metadata_set(value:, metadata_key: nil)
      #   dictionary_hash = dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!]
      #   if metadata_key
      #     dictionary_hash[DICTIONARY_METADATA][metadata_key] = value
      #   else
      #     dictionary_hash[DICTIONARY_METADATA] = value
      #   end
      #   self
      # end

      def dictionary_metadata_set
        raise ArgumentError, 'A block was expected, but no block was passed.' unless block_given?

        yield dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][DICTIONARY_METADATA]

        self
      end

      private

      attr_writer :dictionary_cache, :dictionary_key

      def dictionary_reference
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARY_REFERENCES, key)
      end

      def dictionary_reference_reset(file:, dictionary_id:)
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

      def dictionary_id
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARY_REFERENCES, key, DICTIONARY_ID)
      end

      def dictionary_reset(file:)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!] = {
          FILE => file,
          DICTIONARY_OBJECT => {},
          DICTIONARY_METADATA => {}
        }
      end

      def dictionary_metadata_reset(with:)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][DICTIONARY_METADATA] = with
      end

      def dictionary_object?
        dictionary_object.present?
      end
    end
  end
end
