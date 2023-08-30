# frozen_string_literal: false

require 'pry'

FactoryBot.define do
  factory :dictionary_metadata_service, class: 'LittleWeasel::Services::DictionaryMetadataService' do
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }
    dictionary_metadata { {} }

    skip_create
    initialize_with do
      new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata)
    end
  end
end
