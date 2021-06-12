# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::WordFilterManagable, type: :module do
  WordFilterManagable = described_class

  subject do
    Class.new do
      include WordFilterManagable

      def initialize(word_filters)
        self.word_filters = word_filters
      end
    end.new(word_filters)
  end

  let(:word_filters) do
    word_filters = []
    word_filters << numeric_filter
    word_filters
  end
  let(:numeric_filter) { LittleWeasel::Filters::NumericFilter.new filter_on: filter_on }
  let(:filter_on) { true }

  #filter_match?
  describe '#filter_match?' do
    context 'when argument word is not a String' do
      let(:word) { :not_a_string }

      it 'raises an error' do
        expect { subject.filter_match? word }.to raise_error "Argument word is not a String: #{word.class}"
      end
    end

    context 'when argument word is empty' do
      let(:word) { '' }

      it 'returns false' do
        expect(subject.filter_match? word).to eq false
      end
    end

    context 'when argument word matches a filter' do
      let(:filter_on) { true }
      let(:word) { '123456789' }

      it 'returns true' do
        expect(subject.filter_match? word).to eq true
      end
    end

    context 'when argument word DOES NOT match a filter' do
      let(:filter_on) { false }
      let(:word) { '123456789' }

      it 'returns false' do
        expect(subject.filter_match? word).to eq false
      end
    end
  end
end
