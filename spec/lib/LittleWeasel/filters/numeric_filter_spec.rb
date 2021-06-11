# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::NumericFilter do
  let(:number) { 1 }
  let(:position) { 0 }

  #.word_valid?
  describe '.word_valid?' do
    context 'when word is a number' do
      it 'returns true' do
        [-1.00, -1, 0, 1, 100, 100.10, 1234_56, +100.00, 1_000_000.00].each do |number|
          expect(subject.class.word_valid? number).to eq true
        end
      end
    end

    context 'when word is NOT a number' do
      it 'returns false' do
        expect(subject.class.word_valid? 'a').to eq false
        expect(subject.class.word_valid? :a).to eq false
        expect(subject.class.word_valid? Object.new).to eq false
      end
    end
  end
end
