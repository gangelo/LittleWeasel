# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::PreprocessedWordResultsValidatable, type: :module do
  PreprocessedWordResultsValidatable = described_class

  class MockSubject
    include PreprocessedWordResultsValidatable
  end

  subject do
    MockSubject.new
  end

  before do
    allow(preprocessed_word_results).to receive(:respond_to?).and_call_original
  end

  let(:preprocessed_word_results) do
    create(:preprocessed_word_results,
      original_word: original_word,
      with_word_processors: with_word_processors)
  end
  let(:original_word) { 'word' }
  let(:with_word_processors) { 0 }

  #validate_prepreprocessed_word_results
  describe '#validate_prepreprocessed_word_results' do
    context 'when the object is valid' do
      it 'does not raise an error' do
        expect { subject.validate_prepreprocessed_word_results(preprocessed_word_results: preprocessed_word_results) }.to_not raise_error
      end
    end

    context 'when the object is INVALID' do
      let(:expected_error) { /Argument preprocessed_word_results does not respond to:.+##{method}/ }

      context 'when the object does not respond to #original_word' do
        before { allow(preprocessed_word_results).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :original_word }

        it 'raises an error' do
          expect{ subject.validate_prepreprocessed_word_results(preprocessed_word_results: preprocessed_word_results) }.to raise_error expected_error
        end
      end

      context 'when the object does not respond to #preprocessed_words' do
        before { allow(preprocessed_word_results).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessed_words }

        it 'raises an error' do
          expect{ subject.validate_prepreprocessed_word_results(preprocessed_word_results: preprocessed_word_results) }.to raise_error expected_error
        end
      end
    end
  end
end
