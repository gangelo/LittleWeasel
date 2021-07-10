# frozen_string_literal: false

require 'pry'

FactoryBot.define do
  factory :dictionary_cache_service, class: LittleWeasel::Services::DictionaryCacheService do
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }

    transient do
      # The dictionary reference created in the cache will point to a MEMORY source.
      #
      # Valid values: nil | true | false | <Array of dictionary words>
      #
      # If nil or false - No memory source will be added to the dictionary cache.
      # If true - A memory source will be added to the dictionary cache.
      # If <An Array of dictionary words> - A memory source will be added to the dictionry cache.
      #                                     This only makes sense if load == true.
      dictionary_memory_source {}

      # The dictionary reference created in the cache will point to a FILE source.
      #
      # Important: dictionary_file_source will only be used if dictionary_memory_source
      # is false.
      #
      # Valid values: nil | true | false | <Path to dictionary file>
      #
      # If nil or false - No file source will be added to the dictionary cache.
      #
      # If true - A file source will be added to the dictionry cache.
      #           dictionary_key.key will be used to create the dictionary
      #           file path.
      # If <Path to dictionary file> - A files source will be added to the dictionry cache.
      #                                The file source will point to <Path to dictionary file>.
      dictionary_file_source {}

      # If load == true - A dictionary object will be created and added to the dictionary cache
      #                   depending on the dictionary source (file or memory).
      load { false }
    end

    skip_create
    initialize_with do
      new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
    end

    after :create do |dictionary_cache_service, evaluator|
      dictionary_key = dictionary_cache_service.dictionary_key
      dictionary_cache = dictionary_cache_service.dictionary_cache

      # Initialize the dictionary cache if the user already passed an
      # initialized dictionary cache; otherwise, just use what they passed us.
      dictionary_cache_service.class.init(dictionary_cache: dictionary_cache) \
        unless dictionary_cache_service.class.count(dictionary_cache: dictionary_cache).positive?

      load = evaluator.load
      dictionary_memory_source = evaluator.dictionary_memory_source
      dictionary_file_source = evaluator.dictionary_file_source

      if load
        unless dictionary_memory_source.present? || dictionary_file_source.present?
          raise 'Transient attributes dictionary_memory_source or dictionary_file_source ' \
            "must be present if transient attribute load is true: #{dictionary_reference}"
        end
      end

      if dictionary_file_source
        file_name = if dictionary_file_source == true
          dictionary_key.key
        else
          dictionary_file_source
        end
        dictionary_cache_service.add_dictionary_source(dictionary_source: dictionary_path_for(file_name: file_name))
      elsif dictionary_memory_source
        dictionary_cache_service.add_dictionary_source(dictionary_source: LittleWeasel::Modules::DictionarSourceable.memory_source)
      end

      if load
        dictionary_words = if dictionary_file_source
          dictionary_file_loader_service = create(:dictionary_file_loader_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
          dictionary_file_loader_service.execute
        else
          unless dictionary_memory_source.is_a? Array
            raise 'Transient attribute dictionary_memory_source must be an Array of words ' \
                  "if transient attribute load == true: #{dictionary_memory_source}"
          end
          dictionary_memory_source
        end
        dictionary_cache_service.dictionary_object = create(:dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_words: dictionary_words)
      end

      dictionary_cache_service
    end
  end
end
