# frozen_string_literal: true

require_relative 'dictionary_service'

module LittleWeasel
  module Services
    # This service unloads a dictionary (Dictionary object) associated with
    # the dictionary key from the dictionary cache; however, the dictionary
    # file reference and any metadata associated with the dictionary are
    # maintained in the dictionary cache.
    class DictionaryUnloaderService < DictionaryService
      def execute
        raise NotImplementedError, "TODO: Implement this!"
      end
    end
  end
end
