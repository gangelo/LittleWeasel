# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::WordResults do
  subject { described_class.new original_word: original_word }

  let(:original_word) { 'orgional-word' }

  #.new
  describe '.new' do
    context 'with valid arguments' do
      it 'instantiates the object' do
        expect { subject }.to_not raise_error
      end

      context 'when preprocessed_word is nil' do
        it 'instantiates the object' do
          expect { described_class.new original_word: original_word, preprocessed_word: nil }.to_not raise_error
        end
      end

      context 'when preprocessed_word is a String' do
        it 'instantiates the object' do
          expect { described_class.new original_word: original_word, preprocessed_word: 'word' }.to_not raise_error
        end
      end
    end

    context 'with INVALID arguments' do
      context 'when argument original_word is invalid' do
        it 'raises an error' do
          expect { described_class.new original_word: nil }.to raise_error /Argument original_word is not a String/
        end
      end

      context 'when argument filters_matched is invalid' do
        it 'raises an error' do
          expect { described_class.new original_word: original_word, filters_matched: nil }.to raise_error /Argument filters_matched is not an Array/
        end
      end

      context 'when argument preprocessed_word is invalid' do
        it 'raises an error' do
          expect { described_class.new original_word: original_word, preprocessed_word: :not_a_string }.to raise_error /Argument preprocessed_word is not a String/
        end
      end

      context 'when argument word_cached is invalid' do
        it 'raises an error' do
          expect { described_class.new original_word: original_word, word_cached: nil }.to raise_error /Argument word_cached is not true or false/
        end
      end

      context 'when argument word_valid is invalid' do
        it 'raises an error' do
          expect { described_class.new original_word: original_word, word_valid: nil }.to raise_error /Argument word_valid is not true or false/
        end
      end
    end
  end

  #success?
  describe '#success?' do
    subject { described_class.new original_word: original_word }

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
      before do
        subject.filters_matched = [:matched_filter]
      end

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
      before do
        subject.word_cached = true
      end

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
      before do
        subject.word_valid = true
      end

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
    subject { described_class.new original_word: original_word, preprocessed_word: preprocessed_word }

    context 'when #preprocessed_word is NOT nil' do
      let(:preprocessed_word) { 'word' }

      it 'returns true' do
        expect(subject.preprocessed_word?).to be true
      end
    end

    context 'when #preprocessed_word is nil' do
      let(:preprocessed_word) { nil }

      it 'returns false' do
        expect(subject.preprocessed_word?).to be false
      end
    end
  end
end
