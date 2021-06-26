# frozen_string_literals: true

require 'spec_helper'

RSpec.describe LittleWeasel::Preprocessors::EnUs::CapitalizePreprocessor do
  subject { described_class.new }

  #.new
  describe '.new' do
    it 'instantiates the object' do
      expect { subject }.to_not raise_error
    end

    describe '#order' do
      it 'sets #order to 0 by default' do
        expect(subject.order).to eq 0
      end
    end

    describe '#preprocessor_on' do
      it 'sets #preprocessor_on to true by default' do
        expect(subject.preprocessor_on).to eq true
      end
    end
  end

  #.preprocess
  describe '.preprocess' do
    it 'processes and capitalizes the word' do
      expect(described_class.preprocess 'wOrD').to eq [true, 'Word']
      expect(described_class.preprocess 'Word').to eq [true, 'Word']
    end
  end
end
