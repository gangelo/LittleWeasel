# frozen_string_literal: false

FactoryBot.define do
  factory :numeric_filter, class: LittleWeasel::Filters::EnUs::NumericFilter do
    filter_on { true }

    skip_create
    initialize_with do
      new filter_on: filter_on
    end
  end
end
