# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary_metadata, class: LittleWeasel::Metadata::DictionaryMetadata do
    dictionary {}
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }

    skip_create
    initialize_with do
      dictionary_hash = dictionary || create(:dictionary_hash)
      new dictionary: dictionary_hash, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
    end
  end
end
