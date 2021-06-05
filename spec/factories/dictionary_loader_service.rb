# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary_loader_service, class: LittleWeasel::Services::DictionaryLoaderService do
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }

    skip_create
    initialize_with do
      new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)
    end
  end
end