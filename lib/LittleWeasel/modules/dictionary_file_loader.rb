# frozen_string_literal: true

require_relative '../errors/dictionary_file_already_loaded_error'
require_relative '../errors/dictionary_file_empty_error'
require_relative '../errors/dictionary_file_not_found_error'
require_relative '../errors/dictionary_file_too_large_error'

module LittleWeasel
  module Modules
    # Defines methods to load dictionaries. The dictionary file path is used
    # as a key to avoid loading the same dictionary multiple times.
    module DictionaryFileLoader
      def load(dictionary_file_path)
        Loader.new(dictionary_file_path, config).load
      end

      # Helps with dictionary loading.
      class Loader
        def initialize(dictionary_file_path, config)
          self.dictionary_file_path = dictionary_file_path
          self.config = config
        end

        # Loads but DOES NOT update the dictionaries_hash. Use this if the dictionary
        # DOES NOT need to hang around for any length of time.
        def load
          raise Errors::DictionaryFileNotFoundError unless file_exist?
          raise Errors::DictionaryFileEmptyError if file_empty?
          raise Errors::DictionaryFileTooLargeError if file_too_large?

          load_dictionary
        end

        private

        attr_accessor :config, :dictionary_file_path, :dictionary_words

        def load_dictionary
          prepare_dictionary(File.read(dictionary_file_path, mode: 'r')&.split)
        end

        def prepare_dictionary(words)
          words&.uniq!&.compact!
          words if words.present?
        end

        def file_size
          # File.size? returns nil if file_name doesn't exist or has zero size,
          # the size of the file otherwise.
          @file_size ||= File.size?(dictionary_file_path) || 0
        end

        def file_exist?
          @file_exist ||= File.exist? dictionary_file_path
        end

        def file_empty?
          @file_empty ||= file_exist? && file_size.zero?
        end

        def file_too_large?
          @file_too_large ||= file_exist? && file_size > config.max_dictionary_file_bytes
        end
      end
    end
  end
end
