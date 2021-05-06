# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require_relative 'modules/deep_dup'

module LittleWeasel
  # This class represents a dictionary whose keys represent a language
  # (:en, :es, etc.), language region (:us, :gb, :es, etc.) or a
  # default dictionary file path (:default) for a particular language
  # or region. Values for the keys represented may either be a
  # dictionary file path that points to the dictionary file containing
  # the words associated with that particular language/region. A
  # key's value may also represent another DictionaryHash object if a
  # particular language has one or more region dictionaries associated
  # with it or a default dictionary for that particular language.
  #
  # @example
  #
  #  {
  #    'en' => 'en.txt',
  #    'en-US' => 'en-US.txt',
  #    'en-GB' => 'en-GB.txt',
  #    'es-ES' => 'es-ES.txt',
  #  }
  class DictionariesHash
    # delegate :[], :[]=, :count, :dig, :each_pair, :each_with_object, :key?, :keys, :inject, to: :hash_object
    delegate :[], to: :hash_object

    def initialize(hash: {})
      self.hash_object = {}
      merge! hash
    end

    def to_array
      hash_object.deep_dup.to_a
    end

    def to_hash
      hash_object.deep_dup
    end

    def merge(hash)
      self.class.send :merge, hash, hash_object
    end

    def merge!(hash)
      self.class.send :merge!, hash, hash_object
    end

    # Returns the total number of dictionaries this object
    # represents which is equivalent to the number returned
    # from calling #count on the internal Hash object
    # (hash_object).
    #
    # @example
    #
    #  # If the internal Hash object (hash_object) is:
    #
    #  {
    #    'en' => 'en.txt',
    #    'en-US' => 'en-US.txt',
    #    'en-GB' => 'en-GB.txt',
    #    'es' => 'es.txt',
    #    'es-ES' => 'es-ES.txt',
    #  }
    #
    #  # The following would be returned:
    #
    #  6
    def dictionary_count
      hash_object.count
    end

    class << self
      def merge(hash, dictionaries_hash)
        merge! hash, dictionaries_hash.deep_dup
      end

      def merge!(hash, dictionaries_hash)
        hash = hash.to_hash if hash.is_a? self.class
        dictionaries_hash.merge! hash
      end
    end

    private_class_method :merge, :merge!

    private

    attr_accessor :hash_object
  end
end
