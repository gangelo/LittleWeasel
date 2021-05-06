# frozen_string_literal: false

FactoryBot.define do
  factory :language_dictionary, class: LittleWeasel::Dictionaries::LanguageDictionary do
    language { :en }
    file {}
    tag {}
    skip_create
    initialize_with { new(language: language, file: file, tag: tag) }
  end
end
