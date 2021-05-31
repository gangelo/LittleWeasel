# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'metadata/dictionary_metadata'
require_relative 'services/dictionary_service'

# TODO: What to do if the configuration changes for options
# affecting max_invalid_words_bytesize? e.g.
# max_invalid_words_bytesize, max_invalid_words_bytesize?.
# All (individual?) dictionaries metadata would need to be
# reset.
module LittleWeasel
  class Dictionary < Services::DictionaryService
    delegate :count, to: :dictionary
    delegate :key, to: :dictionary_key

    attr_reader :dictionary, :dictionary_metadata

    def initialize(dictionary_key:, dictionary_cache:, dictionary_words:)
      super(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)

      raise ArgumentError, "Argument dictionary_words is not an Array: #{dictionary_words.class}" unless dictionary_words.is_a?(Array)

      self.dictionary = self.class.to_hash(dictionary_words: dictionary_words)
      # We unconditionally attach metadata to the dictionary. DictionaryMetadata
      # only attaches the metadata services that are turned "on".
      self.dictionary_metadata =
        Metadata::DictionaryMetadata.new(dictionary: dictionary,
                                         dictionary_key: dictionary_key,
                                         dictionary_cache: dictionary_cache)
      self.dictionary_metadata.add_observers
    end

    class << self
      def to_hash(dictionary_words:)
        dictionary_words.each_with_object(Hash.new(false)) { |word, hash| hash[word] = true; }
      end
    end

    def [](word)
      binding.pry
      dictionary_metadata.notify(action: :search, params: { word: word })
    end

    private

    attr_writer :dictionary, :dictionary_metadata
  end
end
