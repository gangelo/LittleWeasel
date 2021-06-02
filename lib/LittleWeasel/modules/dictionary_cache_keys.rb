# frozen_string_literal: true

module LittleWeasel
  module Modules
    module DictionaryCacheKeys
      DICTIONARY_CACHE = 'dictionary_cache'
      NEXT_DICTIONARY_ID = 'next_dictionary_id'
      DICTIONARY_REFERENCES = 'dictionary_references'
      DICTIONARY_ID = 'dictionary_id'
      DICTIONARIES = 'dictionaries'
      FILE = 'file'
      DICTIONARY_OBJECT = 'dictionary_object'

      module_function

      def initialize_dictionary_cache(dictionary_cache:)
        dictionary_cache.each_key { |key| dictionary_cache.delete(key) }
        dictionary_cache[DICTIONARY_CACHE] = initialized_dictionary_cache(include_root: false)
        dictionary_cache
      end

      def initialized_dictionary_cache(include_root: true)
        dictionary_cache = {
          NEXT_DICTIONARY_ID => 0,
          DICTIONARY_REFERENCES => {},
          DICTIONARIES => {}
        }
        return { DICTIONARY_CACHE => dictionary_cache } if include_root

        dictionary_cache
      end
    end
  end
end
