# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::WordPreprocessor do
  subject { described_class.new order: order, preprocessor_on: preprocessor_on }

  let(:preprocessor_on) { true }
  let(:order) { 0 }
  let(:word) { 'word' }

  #.new
  describe '.new' do
    context 'when arguments are valid' do
      it 'instantiates the object' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when arguments are INVALID' do
      context 'when argument order is invalid' do
        context 'when order is not an Integer' do
          let(:order) { :not_an_integer }

          it 'raises an error' do
            expect { subject }.to raise_error(/Argument order is not an Integer/)
          end
        end

        context 'when order is negative' do
          let(:order) { -1 }

          it 'raises an error' do
            expect { subject }.to raise_error "Argument order '#{order}' is not a a number from 0-n"
          end
        end
      end

      context 'when argument preprocessor_on is invalid' do
        context 'when preprocessor_on is not true or false' do
          let(:preprocessor_on) { :not_true_or_false }

          it 'raises an error' do
            expect { subject }.to raise_error "Argument value is not true or false: #{preprocessor_on}"
          end
        end
      end
    end
  end

  #.preprocess
  describe '.preprocess' do
    context 'when not overridden' do
      it 'raises an error' do
        expect { subject.class.preprocess word }.to raise_error LittleWeasel::Errors::MustOverrideError
      end
    end
  end

  #preprocessor_on
  describe '#preprocessor_on' do
    context 'when set to true' do
      before do
        subject.preprocessor_on = true
      end

      it 'returns true' do
        expect(subject.preprocessor_on).to eq true
      end
    end

    context 'when set to false' do
      before do
        subject.preprocessor_on = false
      end

      it 'returns false' do
        expect(subject.preprocessor_on).to eq false
      end
    end
  end

  #preprocessor_on?
  describe '#preprocessor_on?' do
    context 'when #preprocessor_on is true' do
      it 'returns true' do
        expect(subject.preprocessor_on?).to eq true
      end
    end

    context 'when #preprocessor_on is false' do
      let(:preprocessor_on) { false }

      it 'returns false' do
        expect(subject.preprocessor_on?).to eq false
      end
    end
  end

  #preprocess
  describe '#preprocess' do
    context 'when not overridden' do
      it 'raises an error' do
        expect { subject.preprocess 'x' }.to raise_error LittleWeasel::Errors::MustOverrideError
      end
    end

    context 'when overridden' do
      before do
        allow(described_class).to receive(:preprocess?)
          .and_return true
        allow(described_class).to receive(:preprocess)
          .and_return [true, 'preprocessed-word']
      end

      context 'when #preprocessor_on? is true' do
        it 'calls .preprocess and returns a ProcessedWord object' do
          expect(described_class).to receive(:preprocess)
          expect(subject.preprocess word).to be_kind_of LittleWeasel::Preprocessors::PreprocessedWord
        end
      end

      context 'when #preprocessor_on? is false' do
        let(:preprocessor_on) { false }

        it 'does NOT call .preprocess and returns a ProcessedWord object' do
          expect(described_class).to_not receive(:preprocess)
          expect(subject.preprocess word).to be_kind_of LittleWeasel::Preprocessors::PreprocessedWord
        end

      end
    end
  end

  #preprocess?
  describe '#preprocess?' do
    let(:word) { 'word' }

    it 'returns true by default' do
      expect(subject.preprocess? word).to be true
    end

    context 'when #preprocess? returns true' do
      before { allow(subject.class).to receive(:preprocess?).and_return(true) }

      context 'when #preprocessor_on? is true' do
        it_behaves_like 'the preprocessor matches and #preprocessor_on? is true'
      end

      context 'when #preprocessor_on? is false' do
        let(:preprocessor_on) { false }

        it_behaves_like 'the preprocessor matches and #preprocessor_on? is false'
      end
    end

    context 'when #preprocess? returns false' do
      before { allow(subject.class).to receive(:preprocess?).and_return(false) }

      context 'when #preprocessor_on? is true' do
        it_behaves_like 'the preprocessor DOES NOT match and #preprocessor_on? is true'
      end

      context 'when #preprocessor_on? is false' do
        let(:preprocessor_on) { false }

        it_behaves_like 'the preprocessor DOES NOT match and #preprocessor_on? is false'
      end
    end
  end
end
