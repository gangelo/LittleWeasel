# frozen_string_literal: false

FactoryBot.define do
  factory :region_dictionary, class: LittleWeasel::Dictionaries::RegionDictionary do
    language { :en }
    region { :us }
    file {}
    tag {}
    skip_create
    initialize_with { new(language: language, region: region, file: file, tag: tag) }
  end
end
