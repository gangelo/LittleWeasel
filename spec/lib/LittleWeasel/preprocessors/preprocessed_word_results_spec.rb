# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::PreprocessedWordResults, type: :module do
  subject { create(:preprocessed_word_results, original_word: original_word, preprocessed_words: preprocessed_words) }

  let(:original_word) { 'word' }
  let(:preprocessed_words) {}

  #.new
  describe '.new' do
    it 'instantiates an object' do
      expect { subject }.to_not raise_error
    end

    context 'arguments' do
      context '#original_word' do
        it 'sets the original_word attribute' do
          expect(subject.original_word).to eq original_word
        end
      end

      context '#preprocessed_words' do
        let(:preprocessed_words) { [:preprocessed_words] }

        it 'sets the original_word attribute' do
          expect(subject.preprocessed_words).to eq preprocessed_words
        end
      end
    end
  end

  #preprocessed_word
  describe '#preprocessed_word' do
    subject do
      create(:preprocessed_word_results,
        with_word_processors: 3,
        original_word: original_word,
        preprocessed_words: preprocessed_words)
    end

    it 'returns the preprocessed word' do
      expect(subject.preprocessed_word).to eq 'word-0-1-2'
    end
  end

   #preprocessed?
  describe '#preprocessed?' do
    context 'when the word has been preprocessed' do
      subject do
        create(:preprocessed_word_results,
          with_word_processors: 1,
          original_word: original_word,
          preprocessed_words: preprocessed_words)
      end

      it 'returns the preprocessed word' do
        expect(subject.preprocessed?).to eq true
      end
    end

    context 'when the word has NOT been preprocessed' do
      subject do
        create(:preprocessed_word_results,
          original_word: original_word,
          preprocessed_words: preprocessed_words)
      end

      it 'returns the preprocessed word' do
        expect(subject.preprocessed?).to eq false
      end
    end
  end
end


