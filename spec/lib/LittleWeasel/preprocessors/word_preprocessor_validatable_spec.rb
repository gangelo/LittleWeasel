# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::WordPreprocessorValidatable, type: :module do
  subject { MockSubject.new }

  WordPreprocessorValidatable = described_class

  class MockSubject
    include WordPreprocessorValidatable
  end

  class MockWordPreprocessor < LittleWeasel::Preprocessors::WordPreprocessor
    def preprocess(word)
      [true, "#{word}-preprocessed"]
    end
  end

  let(:order) { 0 }
  let(:preprocessor_on) { true }
  let(:word_preprocessor) do
    word_preprocessor = MockWordPreprocessor.new order: order
    word_preprocessor.preprocessor_on = preprocessor_on
    word_preprocessor
  end

  shared_examples 'an instance method is missing' do
    before do
      allow(word_preprocessor).to receive(:respond_to?).with(method).and_return(false)
    end

    it 'raises an error' do
      expect { WordPreprocessorValidatable.validate_word_preprocessor word_preprocessor: word_preprocessor }.to raise_error expected_error_message
    end
  end

  shared_examples 'a class method is missing' do
    before do
      allow(word_preprocessor.class).to receive(:respond_to?).with(method).and_return(false)
    end

    it 'raises an error' do
      expect { WordPreprocessorValidatable.validate_word_preprocessor word_preprocessor: word_preprocessor }.to raise_error expected_error_message
    end
  end

  # .validate_word_preprocessor
  describe '.validate_word_preprocessor' do
    before do
      allow(word_preprocessor.class).to receive(:respond_to?).and_call_original
      allow(word_preprocessor).to receive(:respond_to?).and_call_original
    end

    context 'when the object quacks right' do
      it 'passes validation' do
        expect { WordPreprocessorValidatable.validate_word_preprocessor word_preprocessor: word_preprocessor }.not_to raise_error
      end
    end

    context 'when the object DOES NOT quack right' do
      let(:expected_error_message) { /Argument word_preprocessor: does not respond to/ }

      context 'when a class method is missing' do
        context 'when the class does not respond to .preprocess' do
          let(:method) { :preprocess }

          it_behaves_like 'a class method is missing'
        end

        context 'when the class does not respond to .preprocess?' do
          let(:method) { :preprocess? }

          it_behaves_like 'a class method is missing'
        end
      end

      context 'when an instance method is missing' do
        context 'when the object does not respond to #preprocess' do
          let(:method) { :preprocess }

          it_behaves_like 'an instance method is missing'
        end

        context 'when the object does not respond to #preprocess?' do
          let(:method) { :preprocess? }

          it_behaves_like 'an instance method is missing'
        end

        context 'when the object does not respond to #preprocessor_off?' do
          let(:method) { :preprocessor_off? }

          it_behaves_like 'an instance method is missing'
        end

        context 'when the object does not respond to #preprocessor_on' do
          let(:method) { :preprocessor_on }

          it_behaves_like 'an instance method is missing'
        end

        context 'when the object does not respond to #preprocessor_on=' do
          let(:method) { :preprocessor_on= }

          it_behaves_like 'an instance method is missing'
        end

        context 'when the object does not respond to #preprocessor_on?' do
          let(:method) { :preprocessor_on? }

          it_behaves_like 'an instance method is missing'
        end
      end
    end
  end
end
