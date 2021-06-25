# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryCreatorService do
  include_context 'dictionary keys'
  include_context 'mock word filters'
  include_context 'mock word preprocessors'

  subject { create(:dictionary_creator_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata, word_filters: word_filters, word_preprocessors: word_preprocessors) }

  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:key) { dictionary_key.key }
  let(:file) { dictionary_path_for(file_name: key) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:word_filters) {}
  let(:word_preprocessors) {}

  shared_examples 'it should' do
    context 'with word_filters' do
      context 'when argument word_filters contains word filters' do
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

    context 'with NO word_filters' do
      context 'when argument word_filters is an empty Array' do
        let(:word_filters) { [] }

        it 'creates a dictionary that uses no word filters' do
          expect(dictionary).to be_kind_of LittleWeasel::Dictionary
          expect(dictionary.word_filters).to be_blank
        end
      end

      context 'when argument word_filters is nil' do
        let(:word_filters) {}

        it 'creates a dictionary that uses no word filters' do
          expect(dictionary).to be_kind_of LittleWeasel::Dictionary
          expect(dictionary.word_filters).to be_blank
        end
      end
    end

    context 'with word_preprocessors' do
      let(:word_preprocessors) { [UpcaseWordPreprocessor.new(order: 0)] }
      let(:word) { 'a' }

      context 'when argument word_preprocessors contains word preprocessors' do
        it 'creates a dictionary with the word preprocessors passed' do
          expect(dictionary).to be_kind_of LittleWeasel::Dictionary
          preprocessed_words = dictionary.word_results(word).preprocessed_words
          expect(preprocessed_words.original_word).to eq word
          expect(preprocessed_words.preprocessed_words.count).to eq 1
          expect(preprocessed_words.preprocessed_words[0].original_word).to eq word
          expect(preprocessed_words.preprocessed_words[0].preprocessed_word).to eq word.upcase
          expect(preprocessed_words.preprocessed_words[0].preprocessor).to eq word_preprocessors[0].to_sym
          expect(preprocessed_words.preprocessed_words[0].preprocessed).to eq true
          expect(preprocessed_words.preprocessed_words[0].preprocessor_order).to eq word_preprocessors[0].order
        end
      end
    end

    context 'with NO word_preprocessors' do
      context 'when argument word_preprocessors is an empty Array' do
        let(:word_preprocessors) { [] }

        it 'creates a dictionary that uses no word preprocessors' do
          expect(dictionary).to be_kind_of LittleWeasel::Dictionary
          expect(dictionary.word_preprocessors).to be_blank
        end
      end

      context 'when argument word_preprocessors is nil' do
        let(:word_preprocessors) {}

        it 'creates a dictionary that uses no word preprocessors' do
          expect(dictionary).to be_kind_of LittleWeasel::Dictionary
          expect(dictionary.word_preprocessors).to be_blank
        end
      end
    end
  end

  #from_file_source
  describe '#from_file_source' do
    let(:dictionary) { subject.from_file_source file: file }

    it_behaves_like 'it should'
  end

  #from_memory_source
  describe '#from_memory_source' do
    let(:dictionary) { subject.from_memory_source dictionary_words: dictionary_words }
    let(:dictionary_words) do
      dictionary_words_for dictionary_file_path: file
    end

    it_behaves_like 'it should'
  end
end
