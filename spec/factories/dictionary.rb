# frozen_string_literal: false

FactoryBot.define do
  factory :dictionary, class: LittleWeasel::Dictionaries::Dictionary do
    file {}
    tag {}
    skip_create
    initialize_with { new(file: file, tag: tag) }
  end
end
