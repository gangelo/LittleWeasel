# frozen_string_literal: true

module LittleWeasel
  module Modules
    # Returns true if the dictionary is the dictionary type
    # queried.
    module DictionaryType
      def language_dictionary?
        instance_of? Dictionaries::LanguageDictionary
      end

      def region_dictionary?
        instance_of? Dictionaries::RegionDictionary
      end

      # TODO: Add tagged_dictionary?
    end
  end
end
