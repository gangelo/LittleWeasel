# frozen_string_literal: true

require_relative '../modules/dictionary_cache_keys'
require_relative '../modules/dictionary_cache_validatable'
require_relative '../modules/dictionary_keyable'
require_relative '../modules/dictionary_sourceable'
require_relative '../modules/dictionary_validatable'

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
      include Modules::DictionaryValidatable

      attr_reader :dictionary_cache

      # This class produces the following (example) Hash that represents the
      # dictionary cache structure:
      #
      # @example This is an example:
      #
      # {
      #   'dictionary_cache' =>
      #   {
      #     'dictionary_references' =>
      #     {
      #       'en' =>
      #       {
      #         'dictionary_id' => 19ec7845
      #       },
      #       'en-US' =>
      #       {
      #         'dictionary_id' => 0987a3f2
      #       },
      #       'en-US-temp' =>
      #       {
      #         'dictionary_id' => 9273eac6
      #       }
      #     },
      #     'dictionaries' =>
      #     {
      #       19ec7845 =>
      #         {
      #           'source' => '/en.txt',
      #           'dictionary_object' => {}
      #         },
      #       0987a3f2 =>
      #         {
      #           'source' => '/en-US.txt',
      #           'dictionary_object' => {}
      #         },
      #       9273eac6 =>
      #         {
      #           'source' => '*736ed423',
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
        # This method resets dictionary_cache to its initialized state.
        # This class method is different from the #init instance method
        # in that ALL dictionary references and ALL dictionaries are
        # initialized.
        def init(dictionary_cache:)
          Modules::DictionaryCacheKeys.initialize_dictionary_cache dictionary_cache: dictionary_cache
        end

        # Returns true if the dictionary cache is initialized; that
        # is, if the given dictionary_cache is in the same state the
        # dictionary cache would be in after .init were called.
        def init?(dictionary_cache:)
          initialized_dictionary_cache = init(dictionary_cache: {})
          dictionary_cache.eql?(initialized_dictionary_cache)
        end

        # Returns the number of dictionaries currently in the cache.
        def count(dictionary_cache:)
          dictionary_cache.dig(self::DICTIONARY_CACHE, self::DICTIONARIES)&.keys&.count || 0
        end
      end

      # This method resets the dictionary cache for the given key. This method
      # is different from the .init class method in that ONLY the dictionary
      # reference and dictionary specific to the given key is initialized.
      def init
        # TODO: Do not delete the dictionary if it is being pointed to by
        # another dictionary reference.
        dictionary_cache_hash = dictionary_cache[DICTIONARY_CACHE]
        dictionary_cache_hash[DICTIONARIES]&.delete(dictionary_id)
        dictionary_cache_hash[DICTIONARY_REFERENCES]&.delete(key)
        self
      end

      # Returns true if the dictionary reference exists for the given key; false
      # otherwise. This method is only concerned with the dictionary reference
      # and has nothing to do with whether or not the associated dictionary
      # is actually loaded into the dictionary cache.
      def dictionary_reference?
        dictionary_reference&.present? || false
      end

      # Returns true if a dictionaries Hash key exists for the given dictionary_id
      # in the dictionary cache. This method is only concerned with the existance of
      # the key and has nothing to do with whether or not file/memory sources are
      # present or the presence of a dictionary object.
      def dictionary?
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES].key? dictionary_id
      end

      # Adds a dictionary source. A "dictionary source" specifies the source from which
      # the dictionary ultimately obtains its words.
      #
      # @param source [String] the dictionary source. This can be a file path
      # or a memory source indicator to signify that the dictionary was created
      # dynamically from memory.
      def add_dictionary_source(source:)
        validate_dictionary_source_does_not_exist dictionary_cache_service: self

        dictionary_id = dictionary_id_for_dictionary_source(source: source)
        self.dictionary_reference = dictionary_id
        # Only set the dictionary source if it doesn't already exist because settings
        # the dictionary source wipes out the #dictionary_object; dictionary objects
        # can have more than one dictionary reference pointing to them, and we don't
        # want to blow away the #dictionary_object, metadata, or any other data
        # associated with it if it already exists.
        self.dictionary_source = source unless dictionary?
        self
      end

      # Returns the dictionary id if there is a dictionary id in the dictionary
      # cache associated with the given key; nil otherwise.
      def dictionary_id
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARY_REFERENCES, key, DICTIONARY_ID)
      end

      # Returns the dictionary id if there is a dictionary id in the dictionary
      # cache associated with the given key. This method raises an error if the
      # dictionary id cannot be found.
      def dictionary_id!
        return dictionary_id if dictionary_id?

        raise ArgumentError, "A dictionary id could not be found for key '#{key}'."
      end

      def dictionary_source!
        raise ArgumentError, "A dictionary source could not be found for key '#{key}'." unless dictionary_reference?

        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][SOURCE]
      end
      alias dictionary_file! dictionary_source!

      def dictionary_source
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id, SOURCE)
      end
      alias dictionary_file dictionary_source

      # This method returns true if the dictionary associated with the
      # given dictionary key is loaded/cached. If this is the case,
      # a dictionary object is available in the dictionary cache.
      def dictionary_object?
        dictionary_object.present?
      end
      alias dictionary_exists? dictionary_object?

      # Returns the dictionary object from the dictionary cache for the given
      # key. This method raises an error if the dictionary is not in the cache;
      # that is, if the dictionary was not previously loaded from disk or memory.
      def dictionary_object!
        unless dictionary_object?
          raise ArgumentError,
            "The dictionary object associated with argument key '#{key}' is not in the cache."
        end

        dictionary_object
      end

      def dictionary_object
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES, dictionary_id, DICTIONARY_OBJECT)
      end

      def dictionary_object=(object)
        raise ArgumentError, 'Argument object is not a Dictionary object' unless object.is_a? Dictionary

        unless dictionary_reference?
          raise ArgumentError,
            "The dictionary reference associated with key '#{key}' could not be found."
        end
        return if object.equal? dictionary_object

        if dictionary_exists?
          raise ArgumentError,
            "The dictionary is already loaded/cached for key '#{key}'; use #unload or #kill first."
        end

        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!][DICTIONARY_OBJECT] = object
      end

      private

      attr_writer :dictionary_cache

      def dictionary_reference
        dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARY_REFERENCES, key)
      end

      def dictionary_reference=(dictionary_id)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARY_REFERENCES][key] = {
          DICTIONARY_ID => dictionary_id
        }
      end

      # Returns the dictionary_id for the source if it exists in dictionaries;
      # otherwise, returns the new dictionary id that should be used.
      def dictionary_id_for_dictionary_source(source:)
        dictionary_source?(source: source) || SecureRandom.uuid[0..7]
      end

      # Returns the dictionary_id associated with source if source exists;
      # nil otherwise.
      def dictionary_source?(source:)
        dictionaries = dictionary_cache.dig(DICTIONARY_CACHE, DICTIONARIES)
        dictionaries&.each_pair do |dictionary_id, dictionary_hash|
          return dictionary_id if source == dictionary_hash[SOURCE]
        end
        nil
      end

      def dictionary_source=(source)
        dictionary_cache[DICTIONARY_CACHE][DICTIONARIES][dictionary_id!] = {
          SOURCE => source,
          DICTIONARY_OBJECT => {}
        }
      end

      def dictionary_id?
        dictionary_id.present?
      end
    end
  end
end
