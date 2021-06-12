# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::WordFilterManagable, type: :module do
  WordFilterManagable = described_class

  subject do
    Class.new do
      include WordFilterManagable
      include LittleWeasel::Modules::Configurable

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

  class Filter01 < LittleWeasel::Filters::WordFilter
    class << self
      def filter_match?(word)
        true
      end
    end
  end

  class Filter02 < Filter01; end

  #add_filters
  describe '#add_filters' do
    context 'when argument word_filters is nil' do
      it 'the word filters defined in the configuration are used' do
        expect(subject.add_filters.all? do |word_filter|
          word_filter.is_a? LittleWeasel::Filters::WordFilter
        end).to eq true
      end
    end

    context 'when argument word_filters is NOT nil' do
      it 'the word filters found in argument word_filters are used' do
        expect(subject.add_filters(word_filters: [LittleWeasel::Filters::NumericFilter]).count).to eq 1
        expect(subject.word_filters[0]).to be_kind_of LittleWeasel::Filters::NumericFilter
      end
    end

    context 'when a block is passed' do
      before do
        subject.add_filters do |word_filters|
          word_filters << Filter01
          word_filters << Filter02
        end
      end

      it 'word filters returned from the block are appended and used' do
        expect(subject.word_filters.count).to eq 4
        expect(subject.word_filters).to include(a_kind_of(Filter01))
        expect(subject.word_filters).to include(a_kind_of(Filter02))
        expect(subject.word_filters).to include(a_kind_of(LittleWeasel::Filters::NumericFilter))
        expect(subject.word_filters).to include(a_kind_of(LittleWeasel::Filters::SingleCharacterWordFilter))
      end
    end
  end

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
