# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryCreatorService do
  include_context 'dictionary keys'
  include_context 'mock word filters'

  subject { create(:dictionary_creator_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata, file: file, word_filters: word_filters) }

  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:key) { dictionary_key.key }
  let(:file) { dictionary_path_for(file_name: key) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:word_filters) {}

  #execute
  describe '#execute' do
    context 'when argument word_filters is an empty Array' do
      let(:word_filters) { [] }
      let(:dictionary) { subject.execute }

      it 'creates a dictionary that uses no word filters' do
        expect(dictionary).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary.word_filters).to be_blank
      end
    end

    context 'when argument word_filters is nil' do
      let(:word_filters) {}
      let(:dictionary) { subject.execute }

      it 'creates a dictionary that uses no word filters' do
        expect(dictionary).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary.word_filters).to be_blank
      end
    end

    context 'when argument word_filters contains word filters' do
      let(:dictionary) { subject.execute }
      let(:word_filters) do
        [
          DollarSignFilter.new,
          LittleWeasel::Filters::NumericFilter.new,
          LittleWeasel::Filters::SingleCharacterWordFilter.new
        ]
      end

      it 'creates a dictionary with the word filters passed' do
        expect(dictionary).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary.word_valid?('$').success?).to eq true
        expect(dictionary.word_valid?('1000').success?).to eq true
        expect(dictionary.word_valid?('A').success?).to eq true
      end
    end
  end
end
