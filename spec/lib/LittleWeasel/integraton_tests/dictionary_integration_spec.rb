# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Dictionary integration', type: :integration do
  subject { create(:dictionary_manager) }

  include_context 'dictionary keys'
  include_context 'mock word preprocessors'

  before { LittleWeasel.configure(&:reset) }

  let(:dictionary) do
    subject.create_dictionary_from_file(dictionary_key: dictionary_key, file: dictionary_file_path,
      word_filters: word_filters, word_preprocessors: word_preprocessors)
  end
  let(:dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:dictionary_cache) { subject.dictionary_cache }
  let(:dictionary_metadata) { subject.dictionary_metadata }
  let(:dictionary_file_path) { dictionary_path_for(file_name: dictionary_key.key) }
  let(:dictionary_words) { dictionary_words_for(dictionary_file_path: dictionary_file_path) }
  let(:word_filters) {}
  let(:word_preprocessors) {}

  # word_results
  describe '#word_results' do
    describe 'when using word filters' do
      let(:word_filters) { [LittleWeasel::Filters::EnUs::NumericFilter.new] }
      let(:number) { 1_000.to_s }

      context 'with word filters turned on' do
        let(:word_results) { dictionary.word_results(number) }

        it '#success? returns true' do
          expect(word_results.success?).to be true
        end

        it '#filter_match? returns true' do
          expect(word_results.filter_match?).to be true
        end

        it '#filters_matched returns the filter(s) that were matched' do
          expect(word_results.filters_matched).to eq [:numeric_filter]
        end

        it '#word_valid? returns false' do
          expect(word_results.word_valid?).to be false
        end

        it '#original_word returns the original word' do
          expect(word_results.preprocessed_word_or_original_word).to eq number
        end

        it '#preprocessed_word return nil because no word preprocessors were applied' do
          expect(word_results.preprocessed_word).to be_nil
        end

        it '#preprocessed_word_or_original_word returns the original word' do
          expect(word_results.preprocessed_word_or_original_word).to eq number
        end

        it '#word_cached? returns false if the word is not in the dictionary' do
          expect(word_results.word_cached?).to be false
        end

        it '#word_cached? returns true 2nd-nth time the word was searched if invalid words are being cached by any metadata processing' do
          dictionary.word_results(number)
          expect(word_results.word_cached?).to be true
        end
      end

      context 'with filters turned off' do
        before do
          dictionary.filters_on = false
        end

        let(:word_results) { dictionary.word_results(number) }

        it '#success? returns false' do
          expect(word_results.success?).to be false
        end

        it '#filter_match? returns false' do
          expect(word_results.filter_match?).to be false
        end

        it '#filters_matched returns an empty Array' do
          expect(word_results.filters_matched).to eq []
        end

        it '#word_valid? returns false' do
          expect(word_results.word_valid?).to be false
        end

        it '#original_word returns the original word' do
          expect(word_results.original_word).to eq number
        end

        it '#preprocessed_word return nil because no word preprocessors were applied' do
          expect(word_results.preprocessed_word).to be_nil
        end

        it '#preprocessed_word_or_original_word returns the original word' do
          expect(word_results.preprocessed_word_or_original_word).to eq number
        end

        it '#word_cached? returns false if the word is not in the dictionary' do
          expect(word_results.word_cached?).to be false
        end

        it '#word_cached? returns true 2nd-nth time the word was searched if invalid words are being cached by any metadata processing' do
          dictionary.word_results(number)
          expect(word_results.word_cached?).to be true
        end
      end
    end

    describe 'when using word preprocessors' do
      let(:word_preprocessors) { [DowncaseWordPreprocessor.new(order: 0)] }
      let(:word) { 'ApPlE' }
      let(:word_results) { dictionary.word_results(word) }

      context 'with preprocessors turned on' do
        it '#success? returns true' do
          expect(word_results.success?).to be true
        end

        it '#filter_match? returns false' do
          expect(word_results.filter_match?).to be false
        end

        it '#filters_matched returns the filter(s) that were matched' do
          expect(word_results.filters_matched).to eq []
        end

        it '#word_valid? returns true' do
          expect(word_results.word_valid?).to be true
        end

        it '#original_word returns the original word' do
          expect(word_results.original_word).to eq word
        end

        it '#preprocessed_word returns the preprocessed word' do
          expect(word_results.preprocessed_word).to eq word.downcase
        end

        it '#preprocessed_word_or_original_word returns the preprocessed word' do
          expect(word_results.preprocessed_word_or_original_word).to eq word.downcase
        end

        it '#word_cached? returns true if the word is in the dictionary' do
          expect(word_results.word_cached?).to be true
        end
      end

      context 'with preprocessors turned off' do
        before do
          dictionary.preprocessors_on = false
        end

        it '#success? returns false' do
          expect(word_results.success?).to be false
        end

        it '#filter_match? returns false' do
          expect(word_results.filter_match?).to be false
        end

        it '#filters_matched returns the filter(s) that were matched' do
          expect(word_results.filters_matched).to eq []
        end

        it '#word_valid? returns false' do
          expect(word_results.word_valid?).to be false
        end

        it '#original_word returns the original word' do
          expect(word_results.original_word).to eq word
        end

        it '#preprocessed_word returns nil' do
          expect(word_results.preprocessed_word).to be_nil
        end

        it '#preprocessed_word_or_original_word returns the original word' do
          expect(word_results.preprocessed_word_or_original_word).to eq word
        end

        it '#word_cached? returns false if the word is not in the dictionary' do
          expect(word_results.word_cached?).to be false
        end

        it '#word_cached? returns true 2nd-nth time the word was searched if invalid words are being cached by any metadata processing' do
          dictionary.word_results(word)
          expect(word_results.word_cached?).to be true
        end
      end
    end
  end
end
