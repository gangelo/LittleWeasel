# frozen_string_literal: false

FactoryBot.define do
  factory :preprocessed_word, class: LittleWeasel::Preprocessors::PreprocessedWord do
    original_word {}
    preprocessed {}
    preprocessed_word {}
    preprocessor {}
    preprocessor_order {}

    skip_create
    initialize_with do
      new original_word: original_word, preprocessed: preprocessed, preprocessed_word: preprocessed_word, preprocessor: preprocessor, preprocessor_order: preprocessor_order
    end
  end
end
