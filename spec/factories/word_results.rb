# frozen_string_literal: false

FactoryBot.define do
  factory :word_results, class: 'LittleWeasel::WordResults' do
    original_word {}
    filters_matched { [] }
    preprocessed_words {}
    word_cached { false }
    word_valid { false }

    skip_create
    initialize_with do
      new filters_matched: filters_matched, original_word: original_word, preprocessed_words: preprocessed_words, word_cached: word_cached, word_valid: word_valid
    end
  end
end
