# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::WordFilterManagable, type: :module do
  include_context 'mock word filters'

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

  #clear_filters
  describe '#clear_filters' do
    it 'sets #word_filters to an empty Array ([])' do
      expect { subject.clear_filters }.to \
        change { subject.word_filters.count }.from(1).to(0)
    end
  end

  #add_filters
  describe '#add_filters' do
    context 'when argument word_filters is nil' do
      it 'it requires a block to be passed' do
        expect { subject.add_filters }.to raise_error 'A block is required if argument word_filters is blank'
      end
    end

    context 'when argument word_filters is an blank Array' do
      it 'raises an error' do
        expect { subject.add_filters(word_filters: []) }.to raise_error 'A block is required if argument word_filters is blank'
      end
    end

    context 'when argument word_filters is not an Array' do
      it 'raises an error' do
        expect { subject.add_filters(word_filters: :not_an_array) }.to raise_error /Argument word_filters is not an Array:/
      end
    end

    context 'when argument word_filters is NOT nil' do
      it 'the word filters passed to the method are appended to the #word_filters Array' do
        expect(subject.add_filters(word_filters: [WordFilter01.new, WordFilter02.new]).count).to eq 3
        expect(subject.word_filters).to include(a_kind_of(WordFilter01))
        expect(subject.word_filters).to include(a_kind_of(WordFilter02))
        expect(subject.word_filters).to include(a_kind_of(LittleWeasel::Filters::NumericFilter))
      end
    end

    context 'when a block is passed' do
      before do
        subject.add_filters do |word_filters|
          word_filters << WordFilter01.new
          word_filters << WordFilter02.new
        end
      end

      it 'word filters added from the block are appended to the #word_filters Array' do
        expect(subject.word_filters.count).to eq 3
        expect(subject.word_filters).to include(a_kind_of(WordFilter01))
        expect(subject.word_filters).to include(a_kind_of(WordFilter02))
        expect(subject.word_filters).to include(a_kind_of(LittleWeasel::Filters::NumericFilter))
      end
    end
  end

  #replace_filters
  describe '#replace_filters' do
    it 'replaces any existing word filters' do
      expect(subject.word_filters.count).to eq 1
      expect(subject.word_filters).to include(a_kind_of(LittleWeasel::Filters::NumericFilter))
      expect(subject.replace_filters(word_filters: [WordFilter01.new, WordFilter02.new]).count).to eq 2
      expect(subject.word_filters).to include(a_kind_of(WordFilter01))
      expect(subject.word_filters).to include(a_kind_of(WordFilter02))
    end
  end

  #filters_on=
  describe '#filters_on=' do
    context 'when a boolean is not passed' do
      it 'raises an error' do
        expect { subject.filters_on = :not_a_boolean }.to raise_error /Argument on is not true or false:/
      end
    end

    context 'when true is assigned' do
      it 'turns all the filters on' do
        expect(subject.word_filters.count).to_not be_zero
        expect(subject.word_filters.all? { |word_filter| word_filter.filter_on? })
        subject.filters_on = true
        expect(subject.word_filters.all? { |word_filter| word_filter.filter_off? })
      end
    end

    context 'when false is assigned' do
      let(:filter_on) { false }

      it 'turns all the filters off' do
        expect(subject.word_filters.count).to_not be_zero
        expect(subject.word_filters.all? { |word_filter| word_filter.filter_off? })
        subject.filters_on = false
        expect(subject.word_filters.all? { |word_filter| word_filter.filter_on? })
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
