# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::PreprocessedWordValidatable, type: :module do
  PreprocessedWordValidatable = described_class

  class MockSubject
    include PreprocessedWordValidatable
  end

  subject do
    MockSubject.new
  end

  before do
    allow(preprocessed_word_object).to receive(:respond_to?).and_call_original
  end

  let(:preprocessed_word_object) do
    create(:preprocessed_word,
      original_word: original_word,
      preprocessed: preprocessed,
      preprocessed_word: preprocessed_word,
      preprocessor: preprocessor,
      preprocessor_order: preprocessor_order)
  end
  let(:original_word) { 'word' }
  let(:preprocessed) { true }
  let(:preprocessed_word) { 'preprocessed-word0'}
  let(:preprocessor) { :preprocesor0 }
  let(:preprocessor_order) { 0 }

  #validate_prepreprocessed_word
  describe '#validate_prepreprocessed_word' do
    context 'when the object is valid' do
      it 'does not raise an error' do
        expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to_not raise_error
      end
    end

    context 'when the object is INVALID' do
      context 'when #original_word is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :original_word }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #original_word= is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :original_word= }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessed_word is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessed_word }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessed_word= is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessed_word= }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessed is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessed }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessed= is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessed= }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessed? is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessed? }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessor is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessor }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessor= is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessor= }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessor_order is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessor_order }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end

      context 'when #preprocessor_order= is missing' do
        before { allow(preprocessed_word_object).to receive(:respond_to?).with(method).and_return(false) }
        let(:method) { :preprocessor_order= }

        it 'raises an eror' do
          expect { subject.validate_prepreprocessed_word(preprocessed_word: preprocessed_word_object) }.to raise_error /Argument preprocessed_word: does not respond to.+#{method}/
        end
      end
    end
  end
end
