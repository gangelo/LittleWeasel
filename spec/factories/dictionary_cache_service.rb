# frozen_string_literal: false

require 'pry'

FactoryBot.define do
  factory :dictionary_cache_service, class: LittleWeasel::Services::DictionaryCacheService do
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }

    transient do
      # Values are: false, true or <file name minus extension>
      # If false, no dictionary reference will be added.
      # If true, a dictionary reference based on the dictionary_key.key will be
      #   used (e.g. 'en-US-tag' would equate to: '<path to spec file folder>/en-US.tag.txt').
      # If <file name minus extension>, <file name minus extension> will be
      #   used (e.g. <path to spec file folder>/<file name minus extension>.txt)
      dictionary_reference { false }

      # Set to true if you want the dictionary reference to be loaded from disk.
      load { false }

      # If true, a memory source will be used as opposed to a file source.
      memory_source { false }
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
      dictionary_cache_service.class.init(dictionary_cache: dictionary_cache) unless dictionary_cache_service.class.populated?(dictionary_cache: dictionary_cache)
      if evaluator.dictionary_reference
        file_name = if evaluator.dictionary_reference == true
          dictionary_key.key
        else
          evaluator.dictionary_reference
        end
        dictionary_cache_service.add_dictionary_file_source(file: dictionary_path_for(file_name: file_name))
      #elsif evaluator.memory_source
      end

      if evaluator.load
        unless evaluator.dictionary_reference
          raise 'Transient attribute [dictionary_reference] must be true or contain <file name minus extension> if transient attribute [load] is true'
        end
        dictionary_file_loader_service = create(:dictionary_file_loader_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
        dictionary_words = dictionary_file_loader_service.execute
        dictionary_cache_service.dictionary_object = create(:dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_words: dictionary_words)
      end
    end
  end
end
