# frozen_string_literal: false

FactoryBot.define do
  factory :dictionaries_hash, class: LittleWeasel::DictionariesHash  do
    dictionary_hash { {} }
    skip_create
    initialize_with { new(hash: dictionary_hash) }
  end
end
