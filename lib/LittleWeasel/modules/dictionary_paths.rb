# frozen_string_literal: true

module LittleWeasel
  module Modules
    # Defines methods to find and return dictionary file paths.
    module DictionaryPaths
      # This method attempts to return the dictionary file path
      # requested for the given language and (optional) region;
      # otherwise, an empty string is returned. Unless the configuration
      # specifies otherwise, if a dictionary for the region is not
      # found, the default language dictionary is used (if one exists);
      # if a default language dictionary is not found, an empty string is
      # returned.
      def dictionary_path(hash_key)
        # TODO: Use language_key?, region_key?, tagged_key? instead of the
        # below?
        language, region, _tag = split_key hash_key
        dictionaries_hash[hash_key] ||
          region_dictionary_path(language, region) ||
          language_dictionary_path(language) || ''
      end

      def region_dictionary_path(language, region)
        hash_key = join_key(language: language, region: region)
        dictionaries_hash[hash_key]
      end

      def language_dictionary_path(language)
        hash_key = join_key(language: language)
        dictionaries_hash[hash_key]
      end
    end
  end
end
