# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary_metadata, class: LittleWeasel::Metadata::DictionaryMetadata do
    dictionary_words {}
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }
    dictionary_metadata { {} }

    skip_create
    initialize_with do
      dictionary_hash = dictionary_words || create(:dictionary_hash)
      new dictionary_words: dictionary_hash, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata
    end
  end
end
