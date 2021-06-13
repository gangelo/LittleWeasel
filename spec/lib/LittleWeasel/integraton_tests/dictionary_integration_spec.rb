# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Dictionary integration', type: :integration do
  include_context 'dictionary keys'

  #subject { create(:dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_words: dictionary_words, word_filters: word_filters) }

  before(:each) { LittleWeasel.configure { |config| config.reset } }
  # before do
  #   dictionary_cache_service
  # end

  #let(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: true) }
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

      it '#word_valid? returns true for numbers' do
        dictionary.filters_on = false
        expect(dictionary.word_valid?(number)).to eq false
        dictionary.filters_on = true
        expect(dictionary.word_valid?(number)).to eq true
      end
    end
  end
end
