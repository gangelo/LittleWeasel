# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Dictionary integration', type: :integration do
  include_context 'dictionary keys'

  subject { create(:dictionary_manager) }

  before(:each) { LittleWeasel.configure { |config| config.reset } }

  let(:dictionary) { subject.create_dictionary(dictionary_key: dictionary_key, file: dictionary_file_path, word_filters: word_filters) }
  let(:dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:dictionary_cache) { subject.dictionary_cache }
  let(:dictionary_metadata) { subject.dictionary_metadata }
  let(:dictionary_file_path) { dictionary_path_for(file_name: dictionary_key.key) }
  let(:dictionary_words) { dictionary_words_for(dictionary_file_path: dictionary_file_path) }
  let(:word_filters) {}

  #word_results
  describe '#word_results' do
    describe 'when using word filters' do
      let(:word_filters) { [LittleWeasel::Filters::NumericFilter.new] }
      let(:number) { 1_000.to_s }

      context 'with word filters turned on' do
        let(:word_results) { dictionary.word_results(number) }

        describe 'WordResults return object' do
          it '#success? returns true' do
            expect(word_results.success?).to eq true
          end

          it '#filter_match? returns true' do
            expect(word_results.filter_match?).to eq true
          end

          it '#filters_matched returns the filter(s) that were matched' do
            expect(word_results.filters_matched).to eq [:numeric_filter]
          end

          it '#word_valid? returns false' do
            expect(word_results.word_valid?).to eq false
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
            expect(word_results.word_cached?).to eq false
          end

          it '#word_cached? returns true 2nd-nth time the word was searched if invalid words are being cached by any metadata processing' do
            dictionary.word_results(number)
            expect(word_results.word_cached?).to eq true
          end
        end
      end

      context 'with filters turned off' do
        before do
          dictionary.filters_on = false
        end

        let(:word_results) { dictionary.word_results(number) }

        it 'results are NOT influenced by the word filter(s)' do
          expect(word_results.success?).to eq false
        end

        it 'results indicate NO filter(s) were matched' do
          expect(word_results.filters_matched).to eq []
          expect(word_results.filter_match?).to eq false
        end

      end
    end
  end
end
