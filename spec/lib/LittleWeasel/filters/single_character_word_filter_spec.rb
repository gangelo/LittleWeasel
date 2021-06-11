# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::SingleCharacterWordFilter do
  #.word_valid?
  describe '.word_valid?' do
    context 'when word single character word' do
      it 'returns true' do
        %w(a A I).each do |number|
          expect(subject.class.word_valid? number).to eq true
        end
      end
    end

    context 'when word is NOT a single character word' do
      it 'returns false' do
        expect(subject.class.word_valid? 'X').to eq false
        expect(subject.class.word_valid? :a).to eq false
        expect(subject.class.word_valid? Object.new).to eq false
      end
    end
  end
end
