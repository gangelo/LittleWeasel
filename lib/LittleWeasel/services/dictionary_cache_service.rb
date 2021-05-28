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
      #   {
      #   'dictionary_references' =>
      #     {
      #     'en' =>
      #       {
      #         :dictionary_file_key => '/en.txt'
      #       },
      #     'en-sometag' =>
      #       {
      #         :dictionary_file_key => '/en-sometag.txt'
      #       },
      #     'en-US' =>
      #       {
      #         :dictionary_file_key => '/en-US.txt'
      #       },
      #     }
      #   :dictionary_cache =>
      #     {
      #       '/en.txt' =>
      #         {
      #           :dictionary_metadata => {...},
      #           :dictionary_object => {...}
      #         },
      #       '/en-sometag.txt' =>
      #         {
      #           :dictionary_metadata => {...},
      #           :dictionary_object => {...}
      #         },
      #       '/en-US.txt' =>
      #         {
      #           :dictionary_metadata => {...},
      #           :dictionary_object => {...}
      #         }
      #     }
      #   }
      #
      # @example To initialize a dictionary cache:
      #
      #   dictionary_cache = {}
      #   service = DictionaryCacheService.new(dictionary_cache).reset
      #
      #   # Then use the DictionaryCacheService...
      #   dictioanty_key = dictionary_file_key(language: :en, region: :us)
      #   service.add(key: dictionary_file_key.key, file: '/en-US.txt')
      #
      #   # etc...
      #   service...
      def initialize(dictionary_key:, dictionary_cache:)
        self.dictionary_key = dictionary_key
        validate_dictionary_key

        self.dictionary_cache = dictionary_cache
        validate_dictionary_cache
      end

      class << self
        # This method resets all the DICTIONARY_CACHE_ROOT_KEYS dictionary
        # cache root keys.
        def reset!(dictionary_cache)
          self::DICTIONARY_CACHE_ROOT_KEYS.each { |root_key| dictionary_cache[root_key] = {} }
          dictionary_cache
        end
        alias_method :init!, :reset!
        alias_method :initialize!, :reset!

        # Returns the number of dictionary references. This count
        # has nothing to do with the amount of dictionaries that
        # are loaded, only the amount of dictionary references
        # in the cache.
        def count(dictionary_cache)
          dictionary_cache[self::DICTIONARY_REFERENCES]&.keys&.count || 0
        end

        # Returns true if the dictionary cache is initialized; that
        # is, if it's in the same state the dictionary cache would
        # be in after #reset! is called.
        def init?(dictionary_cache)
          initialized_dictionary_cache = reset!({})

          dictionary_cache.eql?(initialized_dictionary_cache) &&
            self::DICTIONARY_CACHE_ROOT_KEYS.all? { |key| dictionary_cache[key].empty? }
        end
        alias_method :initialized?, :init?

        # Returns true if the dictionary cache has, at a minimum, dictionary
        # references added to it.
        def populated?(dictionary_cache)
          count(dictionary_cache).positive?
        end
      end

      # This method resets all the DICTIONARY_CACHE_ROOT_KEYS dictionary
      # cache root keys for the given key.
      def reset!
        dictionary_cache[DICTIONARY_CACHE]&.delete(dictionary_file_key)
        dictionary_cache[DICTIONARY_REFERENCES]&.delete(key)
        self
      end
      alias_method :init!, :reset!

      # Returns true if the dictionary reference exists for the given key. This
      # method is only concerned with the dictionary reference only and has
      # nothing to do with whether or not the associated dictionary is actually
      # loaded or not; for this, use #loaded?
      def dictionary_reference?
        dictionary_reference&.present? || false
      end

      # Returns true if the dictionary cache exists for the given dictionary key.
      def dictionary_cache?
        dictionary_cache[DICTIONARY_CACHE].key? dictionary_file_key
      end

      # Returns true if a dictionary reference can be added. false is
      # returned if a dictionary reference already exists.
      def add_dictionary_reference?
        !dictionary_reference?
      end

      def add_dictionary_reference(file:)
        unless add_dictionary_reference?
          raise ArgumentError, "Dictionary reference for key '#{key}' already exists."
        end

        dictionary_reference_reset file: file
        dictionary_cache_reset unless dictionary_cache?
        self
      end

      def dictionary_loaded?
        unless dictionary_reference?
          raise ArgumentError, "Argument key '#{key}' does not exist; use #add_dictionary_reference to add it first."
        end

        dictionary_object?
      end
      alias_method :dictionary_cached?, :dictionary_loaded?

      # Returns true if a dictionary file key can be found in the dictionary
      # references for the given key. This method raises an error if the
      # file key cannot be found.
      def dictionary_file_key!
        return dictionary_file_key if dictionary_file_key?

        raise ArgumentError, "Argument key ('#{key}') was not found: { '#{DICTIONARY_REFERENCES}' => { '#{key}' => { '#{DICTIONARY_FILE_KEY}' => '<dictionary file key>' } } }"
      end
      alias_method :dictionary_file!, :dictionary_file_key!

      # Returns the dictionary object from the dictionary cache for the given
      # key. This method raises an error if the dictionary is not in the cache;
      # that is, if the dictionary was not previously loaded.
      def dictionary_object!
        unless dictionary_object?
          raise ArgumentError, "The dictionary associated with argument key '#{key}' is not in the cache; load it from disk first."
        end

        dictionary_object
      end

      def dictionary_object
        return unless dictionary_file_key?

        dictionary_cache.dig(DICTIONARY_CACHE, dictionary_file_key!, DICTIONARY_OBJECT)
      end

      def dictionary_object=(object)
        raise ArgumentError, 'Argument object is not a Dictionary object' unless object.is_a? Dictionary
        raise ArgumentError, "The dictionary reference associated with key '#{key}' could not be found." unless dictionary_reference?

        # TODO:
        # Raise error if the dictionary reference does not exist.
        # Raise 'use #unload or #kill first' if dictionary_loaded? &&
        #   dictionary_object is different from object.
        return self if object == dictionary_object

        raise ArgumentError, "The dictionary is already loaded/cached for key '#{key}'; use #unload or #kill first." if dictionary_loaded?

        dictionary_cache[DICTIONARY_CACHE][dictionary_file_key!][DICTIONARY_OBJECT] = object
      end

      private

      attr_writer :dictionary_cache, :dictionary_key

      def dictionary_reference
        dictionary_cache.dig(DICTIONARY_REFERENCES, key)
      end

      def dictionary_reference_reset(file:)
        dictionary_cache[DICTIONARY_REFERENCES][key] = {
          DICTIONARY_FILE_KEY => file
        }
      end

      def dictionary_file_key?
        dictionary_file_key.present?
      end

      def dictionary_file_key
        dictionary_cache.dig(DICTIONARY_REFERENCES, key, DICTIONARY_FILE_KEY)
      end

      def dictionary_cache_reset
        dictionary_file_key = dictionary_file_key!
        dictionary_cache[DICTIONARY_CACHE][dictionary_file_key] = {
          DICTIONARY_METADATA => {},
          DICTIONARY_OBJECT => {},
        }
      end

      def dictionary_object?
        dictionary_object.present?
      end
    end
  end
end
