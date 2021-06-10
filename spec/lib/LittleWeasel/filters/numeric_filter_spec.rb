# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::NumericFilter do
  subject { create(:numeric_filter, position: position) }

  let(:number) { 1 }
  let(:position) { 0 }

  #.new
  describe '.new' do
    context 'with a valid position' do
      it 'instantiates the filter' do
        expect{ subject }.to_not raise_error
      end
    end

    context 'with an INVALID position' do
      let(:position) {}

      context 'when nil' do
        it 'raises an error' do
          expect{ subject }.to raise_error "Argument position is not a valid position: #{position}"
        end
      end

      context 'when not a number 0-n' do
        let(:position) { :not_a_number }

        it 'raises an error' do
          expect{ subject }.to raise_error "Argument position is not a valid position: #{position}"
        end
      end
    end
  end

  #word_valid?
  describe '#word_valid?' do
    context 'when word is a number' do
      it 'returns true' do
        [-1.00, -1, 0, 1, 100, 100.10, 1234_56, +100.00, 1_000_000.00].each do |number|
          expect(subject.word_valid? number).to eq true
        end
      end
    end

    context 'when word is NOT a number' do
      it 'returns false' do
        expect(subject.word_valid? 'a').to eq false
        expect(subject.word_valid? :a).to eq false
        expect(subject.word_valid? Object.new).to eq false
      end
    end
  end
end
