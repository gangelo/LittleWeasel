# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::PreprocessedWordsValidatable, type: :module do
  PreprocessedWordsValidatable = described_class

  class MockSubject
    include PreprocessedWordsValidatable
  end

  subject do
    MockSubject.new
  end

  before do
    allow(preprocessed_words).to receive(:respond_to?).and_call_original
  end

  let(:preprocessed_words) do
    create(:preprocessed_words,
      original_word: original_word,
      with_word_processors: with_word_processors)
  end
  let(:original_word) { 'word' }
  let(:with_word_processors) { 0 }

  #.validate_prepreprocessed_words
  describe '.validate_prepreprocessed_words' do
    context 'when the object is valid' do
      it 'does not raise an error' do
        expect { PreprocessedWordsValidatable.validate_prepreprocessed_words(preprocessed_words: preprocessed_words) }.to_not raise_error
      end
    end

    context 'when the object is INVALID' do
      let(:expected_error) { /Argument preprocessed_words does not respond to:.+##{method}/ }

      context 'when the object does not respond to #original_word' do
        before { allow(preprocessed_words).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :original_word }

        it 'raises an error' do
          expect{ PreprocessedWordsValidatable.validate_prepreprocessed_words(preprocessed_words: preprocessed_words) }.to raise_error expected_error
        end
      end

      context 'when the object does not respond to #preprocessed_words' do
        before { allow(preprocessed_words).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessed_words }

        it 'raises an error' do
          expect{ PreprocessedWordsValidatable.validate_prepreprocessed_words(preprocessed_words: preprocessed_words) }.to raise_error expected_error
        end
      end
    end
  end
end
