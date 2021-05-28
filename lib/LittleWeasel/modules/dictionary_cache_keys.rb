# frozen_string_literal: true

module LittleWeasel
  module Modules
    module DictionaryCacheKeys
      # DICTIONARY_REFERENCES = 'dictionary_references'
      # DICTIONARY_FILE_KEY = 'dictionary_file_key'
      # DICTIONARY_CACHE = 'dictionary_cache'
      # DICTIONARY_METADATA = 'dictionary_metadata'
      # DICTIONARY_OBJECT = 'dictionary_object'

      # DICTIONARY_CACHE_ROOT_KEYS = [DICTIONARY_REFERENCES, DICTIONARY_CACHE]

      DICTIONARY_CACHE = 'dictionary_cache'
      NEXT_DICTIONARY_ID = 'next_dictionary_id'
      DICTIONARY_KEYS = 'dictionary_keys'
      DICTIONARY_ID = 'dictionary_id'
      DICTIONARIES = 'dictionaries'
      FILE = 'file'
      DICTIONARY_OBJECT = 'dictionary_object'
      DICTIONARY_METADATA = 'dictionary_metadata'

      INITIALIZED_DICTIONARY_CACHE = {
        DICTIONARY_CACHE =>
        {
          NEXT_DICTIONARY_ID => 0,
          DICTIONARY_KEYS => {},
          DICTIONARIES => {}
        }
      }
    end
  end
end
