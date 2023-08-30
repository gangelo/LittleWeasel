# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary_killer_service, class: 'LittleWeasel::Services::DictionaryKillerService' do
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }
    dictionary_metadata { {} }

    skip_create
    initialize_with do
      new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata)
    end
  end
end
