# frozen_string_literal: true

require_relative 'dictionary_service'

module LittleWeasel
  module Services
    # This service removes a dictionary (Dictionary object) associated with
    # the dictionary key from the dictionary cache along with the dictionary
    # file reference and any metadata associated with the dictionary from the
    # dictionary cache.
    class DictionaryKillerService < DictionaryService
      def execute
        raise NotImplementedError, "TODO: Implement this!"
      end
    end
  end
end
