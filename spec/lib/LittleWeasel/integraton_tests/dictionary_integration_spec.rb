# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Dictionary integration', type: :integration do
  include_context 'dictionary keys'

  before(:each) { LittleWeasel.configure { |config| config.reset } }

  let(:dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:dictionary_file_path) { dictionary_path_for(file_name: dictionary_key.key) }
  let(:dictionary_words) { dictionary_words_for(dictionary_file_path: dictionary_file_path) }
  let(:word_filters) {}

  describe 'Dictionary default word filters are applied' do
    subject { create(:dictionary_manager) }

    let(:dictionary) { subject.create_dictionary(dictionary_key: dictionary_key, file: dictionary_file_path) }
    let(:dictionary_cache) { subject.dictionary_cache }
    let(:dictionary_metadata) { subject.dictionary_metadata }

    context 'NumericFilter is applied' do
      let(:number) { 1_000.to_s }

      context 'filters are turned on by default' do
        let(:results) { dictionary.word_valid?(number) }

        it '#word_valid? returns true for numbers with the filters turned on' do
          expect(results.success?).to eq true
        end

        it 'returns the filters that were matched' do
          expect(results.filters_matched).to eq [:numeric_filter]
        end
      end

      context 'with filters turned off' do
        before do
          dictionary.filters_on = false
        end

        let(:results) { dictionary.word_valid?(number) }

        it '#word_valid? returns false for numbers with the filters turned off' do
          expect(results.success?).to eq false
        end

        it 'returns no filters matched' do
          expect(results.filters_matched).to eq []
        end
      end
    end
  end
end
