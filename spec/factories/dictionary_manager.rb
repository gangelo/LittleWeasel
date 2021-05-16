# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary_manager, class: LittleWeasel::DictionaryManager do
    skip_create
    initialize_with { new }
  end
end
