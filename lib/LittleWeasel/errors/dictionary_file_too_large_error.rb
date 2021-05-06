# frozen_string_literal: true

module LittleWeasel
  module Errors
    # Describes an error when a the dictionary file is too large.
    class DictionaryFileTooLargeError < StandardError
      def initialize(msg: nil)
        unless msg.present?
          msg = 'The dictionary file size is larger than ' \
            "max_dictionary_file_megabytes: #{LittleWeasel.configuration.max_dictionary_file_megabytes}"
        end
        super msg
      end
    end
  end
end
