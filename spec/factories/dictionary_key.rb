# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary_key, class: LittleWeasel::Dictionaries::DictionaryKey do
    language { :en }
    region { :us }
    tag {}

    skip_create
    initialize_with do
      new language: language, region: region, tag: tag
    end
  end
end
