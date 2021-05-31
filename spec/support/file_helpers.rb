# frozen_string_literal: true

require_relative '../../lib/LittleWeasel/modules/locale'

module Support
  # This module contains methods to help with dictionary files.
  module FileHelpers
    include LittleWeasel::Modules::Locale

    def region_dictionary_path language:, region:
      file_name = FileHelpers.locale language: language, region: region
      dictionary_path_for file_name: file_name
    end

    def language_dictionary_path language:
      file_name = FileHelpers.locale language:language
      dictionary_path_for file_name: file_name
    end

    # :reek:UtilityFunction - ignored, this is only for specs.
    def dictionary_path_for(locale: nil, file_name: nil)
      file_name ||= locale
      File.join(File.dirname(__FILE__), "files/#{file_name}.txt")
    end

    def dictionary_words_for(dictionary_file_path:)
      File.read(dictionary_file_path, mode: 'r')&.split
    end
  end
end
