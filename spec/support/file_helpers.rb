# frozen_string_literal: true

require_relative '../../lib/LittleWeasel/modules/locale'

module Support
  # This module contains methods to help with dictionary
  # files.
  module FileHelpers
    include LittleWeasel::Modules::Locale

    def region_dictionary_path language:, region:
      file_name = locale_from language: language, region: region
      build_dictionary_path_for file_name: file_name
    end

    def language_dictionary_path language:
      file_name = language_from language
      build_dictionary_path_for file_name: file_name
    end

    # :reek:UtilityFunction - ignored, this is only for specs.
    def build_dictionary_path_for file_name:
      File.join(File.dirname(__FILE__), "files/#{file_name}.txt")
    end
  end
end
