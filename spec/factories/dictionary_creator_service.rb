# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary_creator_service, class: LittleWeasel::Services::DictionaryCreatorService do
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }
    dictionary_metadata { {} }
    word_filters {}

    skip_create
    initialize_with do
      new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata, word_filters: word_filters)
    end
  end
end
