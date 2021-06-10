# frozen_string_literal: false

FactoryBot.define do
  factory :numeric_filter, class: LittleWeasel::Filters::NumericFilter do
    position { 0 }

    skip_create
    initialize_with do
      new position
    end
  end
end
