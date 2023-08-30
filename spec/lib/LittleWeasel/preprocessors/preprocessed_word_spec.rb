# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::PreprocessedWord do
  subject do
    described_class.new(
      original_word: original_word,
      preprocessed_word: preprocessed_word,
      preprocessor: preprocessor,
      preprocessed: preprocessed,
      preprocessor_order: preprocessor_order
    )
  end

  let(:original_word) { :original_word }
  let(:preprocessed_word) { :preprocessed_word }
  let(:preprocessor) { :preprocessor }
  let(:preprocessed) { true }
  let(:preprocessor_order) { :preprocessor_order }

  # .new
  describe '.new' do
    context 'initializes the attributes' do
      describe '#original_word' do
        it 'is initialized' do
          expect(subject.original_word).to eq :original_word
        end
      end

      describe '#preprocessed_word' do
        it 'is initialized' do
          expect(subject.preprocessed_word).to eq :preprocessed_word
        end
      end

      describe '#preprocessor' do
        it 'is initialized' do
          expect(subject.preprocessor).to eq :preprocessor
        end
      end

      describe '#preprocessor_order' do
        it 'is initialized' do
          expect(subject.preprocessor_order).to eq :preprocessor_order
        end
      end
    end
  end

  # attributes
  context 'attributes' do
    describe 'original_word=' do
      let(:changed_to) { :original_word_changed }

      it 'sets the attribute' do
        subject.original_word = changed_to
        expect(subject.original_word).to eq changed_to
      end
    end

    describe 'preprocessed_word=' do
      let(:changed_to) { :preprocessed_word_changed }

      it 'sets the attribute' do
        subject.preprocessed_word = changed_to
        expect(subject.preprocessed_word).to eq changed_to
      end
    end

    describe 'preprocessor=' do
      let(:changed_to) { :preprocessor_changed }

      it 'sets the attribute' do
        subject.preprocessor = changed_to
        expect(subject.preprocessor).to eq changed_to
      end
    end

    describe 'preprocessor_order=' do
      let(:changed_to) { :preprocessor_order_changed }

      it 'sets the attribute' do
        subject.preprocessor_order = changed_to
        expect(subject.preprocessor_order).to eq changed_to
      end
    end

    describe '#preprocessed?' do
      context 'when preprocessed is true' do
        it 'returns true' do
          expect(subject.preprocessed?).to be true
        end
      end

      context 'when preprocessed is false' do
        let(:preprocessed) { false }

        it 'returns false' do
          expect(subject.preprocessed?).to be false
        end
      end
    end
  end
end
