# frozen_string_literal: true

require_relative '../errors/dictionary_file_already_loaded_error'
require_relative '../errors/dictionary_file_empty_error'
require_relative '../errors/dictionary_file_not_found_error'
require_relative '../errors/dictionary_file_too_large_error'
require_relative '../services/dictionary_hash_service'
require_relative 'dictionary_paths'
require_relative 'hash_keys'

module LittleWeasel
  module Modules
    # Defines methods to load dictionaries. The dictionary file path is used
    # as a key to avoid loading the same dictionary multiple times.
    module DictionaryLoader
      include DictionaryPaths
      include HashKeys

      # def load_using_locale(language:, region: nil, tag: nil)
      #   hash_key = join_key language: language, region: region, tag: tag
      #   load_using_file dictionary_path hash_key
      # end

      # def load_using_locale!(language:, region: nil, tag: nil)
      #   hash_key = join_key language: language, region: region, tag: tag
      #   load_using_file! dictionary_path hash_key
      # end

      # def load_using_hash_key(hash_key)
      #   load_using_locale(**split_key_to_hash(hash_key))
      # end

      # def load_using_hash_key!(hash_key)
      #   load_using_locale!(**split_key_to_hash(hash_key))
      # end

      # Loads but DOES NOT update the dictionaries_hash.
      # Use this if the dictionary DOES NOT need to hang around for any length of time.
      def load_using_file(dictionary_file_path)
        Loader.new(dictionary_file_path, dictionaries_hash).load
      end

      # Loads and updates the dictionaries_hash.
      # Use this if the dictionary needs to hang around for a while.
      def load_using_file!(dictionary_file_path)
        Loader.new(dictionary_file_path, dictionaries_hash).load!
      end

      # Helps with dictionary loading.
      class Loader
        LOADED_DICTIONARIES_KEY = :loaded_dictionaries

        def initialize(dictionary_file_path, dictionaries_hash)
          self.dictionary_file_path = dictionary_file_path
          self.dictionaries_hash = dictionaries_hash
        end

        # Loads but DOES NOT update the dictionaries_hash. Use this if the dictionary
        # DOES NOT need to hang around for any length of time.
        def load
          return dictionary.dup if dictionary_loaded?

          raise Errors::DictionaryFileNotFoundError unless file_exist?
          raise Errors::DictionaryFileEmptyError if file_empty?
          raise Errors::DictionaryFileTooLargeError if file_too_large?

          load_dictionary
        end

        # Loads the dictionary words and returns a dictionary word hash. Raises
        # an error if the dictionary is already loaded.
        def load!
          raise Errors::DictionaryFileAlreadyLoadedError if dictionary_loaded?

          (dictionaries_hash[LOADED_DICTIONARIES_KEY] ||= {}).tap do |hash|
            hash[dictionary_file_path_sym] = load
          end[dictionary_file_path_sym]
        end

        private

        attr_accessor :dictionary_file_path, :dictionaries_hash

        def load_dictionary
          # TODO: Create an indexer that keeps track of the blocks of
          # words for each letter in the alphabet, so that we only have
          # to search the dictionary within the alphabet range in which
          # the word resides.
          dictionary_words = prepare_dictionary(File.read(dictionary_file_path, mode: 'r')&.split)
          Services::DictionaryHashService.new(dictionary_words).execute
        end

        def prepare_dictionary(words)
          words&.uniq!&.compact!
          words if words.present?
        end

        def dictionary_loaded?
          dictionary.is_a? Hash
        end

        # Warning: This method returns an alterable Hash; use #dup
        # where appropriate!
        def dictionary
          dictionaries_hash.dig LOADED_DICTIONARIES_KEY, dictionary_file_path_sym
        end

        def dictionary_file_path_sym
          @dictionary_file_path_sym ||= dictionary_file_path.to_sym
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

        def config
          @config ||= LittleWeasel.configuration
        end
      end
    end
  end
end
