# frozen_string_literal: false

require 'pry'

FactoryBot.define do
  factory :preprocessed_words, class: 'LittleWeasel::Preprocessors::PreprocessedWords' do
    original_word { 'word' }
    preprocessed_words {}

    transient do
      with_word_processors { 0 }
    end

    skip_create
    initialize_with do
      new original_word: original_word, preprocessed_words: preprocessed_words
    end

    after :create do |preprocessed_words, evaluator|
      with_word_processors = evaluator.with_word_processors

      if with_word_processors.positive?
        preprocessed_words.preprocessed_words = []
        preprocessed_word = evaluator.original_word

        with_word_processors.times do |index|
          preprocessed_word_object = create(:preprocessed_word,
            original_word: preprocessed_word,
            preprocessed: true,
            preprocessed_word: "#{preprocessed_word}-#{index}").tap do |preprocessed_word_object|
            preprocessed_word_object.preprocessed_word = "#{preprocessed_word}-#{index}"
            preprocessed_word_object.preprocessor = "preprocesor#{index}"
            preprocessed_word_object.preprocessor_order = index
          end
          preprocessed_words.preprocessed_words << preprocessed_word_object
          preprocessed_word = preprocessed_word_object.preprocessed_word
        end
      end
    end
  end
end
