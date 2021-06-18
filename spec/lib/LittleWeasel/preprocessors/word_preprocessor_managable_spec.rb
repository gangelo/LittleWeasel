# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::WordPreprocessorManagable, type: :module do
  subject { MockSubject.new }

  WordPreprocessorManagable = described_class

  class MockSubject
    include WordPreprocessorManagable
  end

  subject { MockSubject.new }

  class MockWordPreprocessor01 < LittleWeasel::Preprocessors::WordPreprocessor
    def initialize(order: 0, preprocessor_on: true)
      super order: order, preprocessor_on: preprocessor_on
    end

    class << self
      def preprocess(word) [true, "#{word}-0"]; end
    end
  end

  class MockWordPreprocessor02 < MockWordPreprocessor01
    def initialize
      super order: 1
    end

    class << self
      def preprocess(word) [true, "#{word}-1"]; end
    end
  end

  class MockWordPreprocessor03 < MockWordPreprocessor01
    def initialize
      super order: 2
    end

    class << self
      def preprocess(word) [true, "#{word}-2"]; end
    end
  end

  let(:word_preprocessors_01_thru_03) do
    [MockWordPreprocessor03.new,
      MockWordPreprocessor02.new,
      MockWordPreprocessor01.new]
  end

  class MockWordPreprocessor04 < MockWordPreprocessor01
    def initialize
      super order: 3
    end

    class << self
      def preprocess(word) [true, "#{word}-3"]; end
    end
  end

  class MockWordPreprocessor05 < MockWordPreprocessor01
    def initialize
      super order: 4
    end

    class << self
      def preprocess(word) [true, "#{word}-4"]; end
    end
  end

  class MockWordPreprocessor06 < MockWordPreprocessor01
    def initialize
      super order: 5
    end

    class << self
      def preprocess(word) [true, "#{word}-5"]; end
    end
  end

  let(:word_preprocessors_04_thru_06) do
    [MockWordPreprocessor06.new,
      MockWordPreprocessor05.new,
      MockWordPreprocessor04.new]
  end

  #word_preprocessors
  describe '#word_preprocessors' do
    it 'returns an empty Array ([]) by default' do
      expect(subject.word_preprocessors).to eq []
    end
  end

  #clear_preprocessors
  describe '#clear_preprocessors' do
    before do
      subject.replace_preprocessors word_preprocessors: word_preprocessors_01_thru_03
    end

    it 'clears #word_preprocessors' do
      expect { subject.clear_preprocessors }.to change { subject.word_preprocessors.count }.from(3).to(0)
    end
  end

  #add_preprocessors
  describe '#add_preprocessors' do
    context 'when passing an INVALID argument' do
      context 'when passing an Array of invalid word preprocessors' do
        it 'raises an error' do
          expect { subject.add_preprocessors(word_preprocessors: %i(bad word preprocessors)) }.to raise_error /Argument word_preprocessor does not respond to/
        end
      end
    end

    context 'when passing a valid argument' do
      before do
        subject.replace_preprocessors word_preprocessors: word_preprocessors_04_thru_06
      end

      let(:expected_results) do
        word_preprocessors_01_thru_03.concat(word_preprocessors_04_thru_06).sort_by(&:order)
      end

      it 'adds the word preprocessors to the #word_preprocessors and sorts the #word_preprocessors Array by WordPreprocessor#order' do
        expect { subject.add_preprocessors word_preprocessors: word_preprocessors_01_thru_03 }.to \
          change { subject.word_preprocessors.count }.from(3).to(6)
        expect(subject.word_preprocessors).to eq expected_results
      end
    end
  end

  #replace_preprocessors
  describe '#replace_preprocessors' do
    before do
      subject.add_preprocessors word_preprocessors: word_preprocessors_01_thru_03
    end

    let(:expected_results) do
      word_preprocessors_04_thru_06.sort_by(&:order)
    end

    it 'replaces the word preprocessors in #word_preprocessors and sorts the #word_preprocessors Array by WordPreprocessor#order' do
      expect(subject.word_preprocessors).to match_array word_preprocessors_01_thru_03
      expect(subject.replace_preprocessors word_preprocessors: word_preprocessors_04_thru_06).to eq expected_results
      expect(subject.word_preprocessors).to eq expected_results
    end
  end

  #preprocessors_on=
  describe '#preprocessors_on=' do
    context 'when assigning true' do
      before do
        subject.preprocessors_on = false
        expect(subject.word_preprocessors.map(&:preprocessor_on)).to all(be false)
      end

      it 'sets all preprocessors on' do
        subject.preprocessors_on = true
        expect(subject.word_preprocessors.map(&:preprocessor_on)).to all(be true)
      end
    end

    context 'when assigning false' do
      before do
        subject.preprocessors_on = true
        expect(subject.word_preprocessors.map(&:preprocessor_on)).to all(be true)
      end

      it 'sets all preprocessors off' do
        subject.preprocessors_on = false
        expect(subject.word_preprocessors.map(&:preprocessor_on)).to all(be false)
      end
    end
  end

  #preprocess
  describe '#preprocess' do
    before do
      subject.add_preprocessors word_preprocessors: word_preprocessors
    end

    let(:word) { 'word' }
    let(:word_preprocessors) { word_preprocessors_01_thru_03 }

    it 'preprocesses the word' do
      expect(subject.word_preprocessors.count).to eq word_preprocessors.count
      expect(subject.preprocess(word).map(&:preprocessed_word)).to eq %w(word-0 word-0-1 word-0-1-2)
    end
  end
end
