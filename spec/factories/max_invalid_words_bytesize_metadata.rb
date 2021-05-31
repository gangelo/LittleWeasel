# frozen_string_literal: false

FactoryBot.define do
  factory :max_invalid_words_bytesize_metadata, class: LittleWeasel::Metadata::MaxInvalidWordsBytesizeMetadata do
    dictionary_metadata {}
    dictionary {}
    dictionary_key { create(:dictionary_key) }
    dictionary_cache { {} }

    skip_create
    initialize_with do
      new dictionary_metadata: dictionary_metadata || create(:dictionary_metadata, dictionary: dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache),
          dictionary: dictionary,
          dictionary_key: dictionary_key,
          dictionary_cache: dictionary_cache
    end
  end
end
