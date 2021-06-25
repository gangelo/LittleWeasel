# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryCreatorService do
  include_context 'dictionary keys'
  include_context 'mock word filters'

  subject { create(:dictionary_creator_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata, word_filters: word_filters) }

  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:key) { dictionary_key.key }
  let(:file) { dictionary_path_for(file_name: key) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:word_filters) {}

  #from_file_source
  describe '#from_file_source' do
    context 'when argument word_filters is an empty Array' do
      let(:word_filters) { [] }
      let(:dictionary) { subject.from_file_source file: file }

      it 'creates a dictionary that uses no word filters' do
        expect(dictionary).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary.word_filters).to be_blank
      end
    end

    context 'when argument word_filters is nil' do
      let(:word_filters) {}
      let(:dictionary) { subject.from_file_source file: file }

      it 'creates a dictionary that uses no word filters' do
        expect(dictionary).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary.word_filters).to be_blank
      end
    end

    context 'when argument word_filters contains word filters' do
      let(:dictionary) { subject.from_file_source file: file }
      let(:word_filters) do
        [
          DollarSignFilter.new,
          LittleWeasel::Filters::EnUs::NumericFilter.new,
          LittleWeasel::Filters::EnUs::SingleCharacterWordFilter.new
        ]
      end

      it 'creates a dictionary with the word filters passed' do
        expect(dictionary).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary.word_results('$').success?).to eq true
        expect(dictionary.word_results('1000').success?).to eq true
        expect(dictionary.word_results('A').success?).to eq true
      end
    end
  end

  #from_memory_source
  describe '#from_memory_source' do
    it 'does something'
  end
end
