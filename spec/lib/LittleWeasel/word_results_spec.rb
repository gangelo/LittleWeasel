# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::WordResults do
  subject do
    create(:word_results,
      original_word: original_word,
      filters_matched: filters_matched,
      preprocessed_word_results: preprocessed_word_results,
      word_cached: word_cached,
      word_valid: word_valid)
  end

  let(:original_word) { 'original-word' }
  let(:filters_matched) { [] }
  let(:preprocessed_word_results) {}
  let(:word_cached) { false }
  let(:word_valid) { false }

  #.new
  describe '.new' do
    context 'with valid arguments' do
      it 'instantiates the object' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with INVALID arguments' do
      context 'when argument original_word is invalid' do
        let(:original_word) {}

        it 'raises an error' do
          expect { subject }.to raise_error /Argument original_word is not a String/
        end
      end

      context 'when argument filters_matched is invalid' do
        let(:filters_matched) {}

        it 'raises an error' do
          expect { subject }.to raise_error /Argument filters_matched is not an Array/
        end
      end

      context 'when argument preprocessed_word_results is invalid' do
        let(:preprocessed_word_results) { :invalid }

        it 'raises an error' do
          expect { subject }.to raise_error /Argument preprocessed_word_results does not respond to/
        end
      end

      context 'when argument word_cached is invalid' do
        let(:word_cached) {}

        it 'raises an error' do
          expect { subject }.to raise_error /Argument word_cached is not true or false/
        end
      end

      context 'when argument word_valid is invalid' do
        let(:word_valid) {}

        it 'raises an error' do
          expect { subject }.to raise_error /Argument word_valid is not true or false/
        end
      end
    end
  end

  #success?
  describe '#success?' do
    context 'when #filter_match? is false AND #word_valid? is false' do
      before do
        allow(subject).to receive(:filter_match?).and_return false
        allow(subject).to receive(:word_valid?).and_return false
      end

      it 'returns false' do
        expect(subject.success?).to be false
      end
    end

    context 'when #filter_match? is true OR #word_valid? is true' do
      context 'when #filter_match? is true' do
        before do
          allow(subject).to receive(:filter_match?).and_return true
          allow(subject).to receive(:word_valid?).and_return false
        end

        it 'returns true' do
          expect(subject.success?).to be true
        end
      end

      context 'when #word_valid? is true' do
        before do
          allow(subject).to receive(:filter_match?).and_return false
          allow(subject).to receive(:word_valid?).and_return true
        end

        it 'returns true' do
          expect(subject.success?).to be true
        end
      end
    end
  end

  #filter_match?
  describe '#filter_match?' do
    context '#when filters_matched is present' do
      let(:filters_matched) { [:matched_filter] }

      it 'returns true' do
        expect(subject.filter_match?).to eq true
      end
    end

    context '#when filters_matched is NOT present' do
      it 'returns false' do
        expect(subject.filter_match?).to eq false
      end
    end
  end

  #word_cached?
  describe '#word_cached?' do
    context '#when word_cached is true' do
      let(:word_cached) { true }

      it 'returns true' do
        expect(subject.word_cached?).to eq true
      end
    end

    context '#when word_cached is false' do
      it 'returns false' do
        expect(subject.word_cached?).to eq false
      end
    end
  end

  #word_valid?
  describe '#word_valid?' do
    context '#when word_valid is true' do
      let(:word_valid) { true }

      it 'returns true' do
        expect(subject.word_valid?).to eq true
      end
    end

    context '#when word_valid is false' do
      it 'returns false' do
        expect(subject.word_valid?).to eq false
      end
    end
  end

  #preprocessed_word?
  describe '#preprocessed_word?' do
    subject do
      create(:word_results,
        original_word: original_word,
        filters_matched: [],
        preprocessed_word_results: preprocessed_word_results,
        word_cached: false,
        word_valid: false)
    end

    context 'when #preprocessed_word is NOT nil' do
      let(:preprocessed_word_results) do
        create(:preprocessed_word_results, with_word_processors: 2)
      end

      it 'returns true' do
        expect(subject.preprocessed_word?).to be true
      end
    end

    context 'when #preprocessed_word is nil' do
      let(:preprocessed_word_results) do
        create(:preprocessed_word_results)
      end

      it 'returns false' do
        expect(subject.preprocessed_word?).to be false
      end
    end
  end

  #preprocessed_word_or_original_word
  describe '#preprocessed_word_or_original_word' do
    context 'when the word has been preprocessed' do
      it 'returns #preprocesed_word'
    end

    context 'when the word has NOT been preprocessed' do
      it 'returns #original_word'
    end
  end
end
