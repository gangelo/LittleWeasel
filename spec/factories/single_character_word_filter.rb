# frozen_string_literal: false

FactoryBot.define do
  factory :single_character_word_filter, class: 'LittleWeasel::Filters::EnUs::SingleCharacterWordFilter' do
    filter_on { true }

    skip_create
    initialize_with do
      new filter_on: filter_on
    end
  end
end
