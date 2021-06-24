# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::WordPreprocessorsValidatable, type: :module do
  subject { MockSubject.new }

  WordPreprocessorsValidatable = described_class

  class MockSubject
    include WordPreprocessorsValidatable
  end

  subject { MockSubject.new }

  class MockWordPreprocessor < LittleWeasel::Preprocessors::WordPreprocessor
    def initialize(order: 0, preprocessor_on: true)
      super order: order, preprocessor_on: preprocessor_on
    end

    class << self
      def preprocess(word) [true, "#{word}-0"]; end
    end
  end

  #.validate_word_preprocessors
  describe '.validate_word_preprocessors' do
    context 'when passing a blank Array' do
      it 'passes validaton' do
        expect { WordPreprocessorsValidatable.validate_word_preprocessors(word_preprocessors: []) }.to_not raise_error
      end
    end

    context 'when passing a an Array with valid word preprocessors' do
      it 'passes validation' do
        expect { WordPreprocessorsValidatable.validate_word_preprocessors(word_preprocessors: [MockWordPreprocessor.new]) }.to_not raise_error
      end
    end

    context 'when passing an INVALID argument' do
      context 'when passing an invalid Array' do
        it 'raises an error' do
          expect { WordPreprocessorsValidatable.validate_word_preprocessors(word_preprocessors: :not_an_array) }.to raise_error(/Argument word_preprocessors is not an Array/)
        end
      end
    end
  end
end
