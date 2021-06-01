# frozen_string_literal: false
require 'pry'
FactoryBot.define do
  factory :max_invalid_words_bytesize_metadata, class: LittleWeasel::Metadata::MaxInvalidWordsBytesizeMetadata do
    dictionary_metadata {}
    dictionary {}
    dictionary_key {}
    dictionary_cache {}

    skip_create
    initialize_with do
      new dictionary_metadata: dictionary_metadata ,
          dictionary: dictionary,
          dictionary_key: dictionary_key,
          dictionary_cache: dictionary_cache
    end

    before :create do |max_invalid_words_bytesize_metadata, evaluator|
      binding.pry
      create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: true)
    end
  end
end
