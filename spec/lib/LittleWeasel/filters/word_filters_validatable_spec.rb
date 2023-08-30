# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::WordFiltersValidatable, type: :module do
  subject { Subject.new }

  include_context 'mock word filters'

  WordFiltersValidatable = described_class

  class Subject
    include WordFiltersValidatable
  end

  let(:word_filters) do
    [
      WordFilter01.new,
      WordFilter02.new
    ]
  end
  let(:expected_error_message) { "Argument word_filter does not quack right: #{numeric_filter.class}" }

  # validate_word_filters
  describe '#validate_word_filters' do
    context 'when argument word_filters is not an Array' do
      let(:word_filters) { :not_an_array }

      it 'raises an error' do
        expect { subject.validate_word_filters(word_filters: word_filters) }.to raise_error "Argument word_filters is not an Array: #{word_filters.class}"
      end
    end

    context 'when argument word_filters contains valid word filters' do
      it 'does not raise an error' do
        expect { subject.validate_word_filters(word_filters: word_filters) }.not_to raise_error
      end
    end

    context 'when argument word_filters contains INVALID word filters' do
      let(:word_filters) { [Object.new] }

      it 'does not raise an error' do
        expect { subject.validate_word_filters(word_filters: word_filters) }.to raise_error "Argument word_filter does not quack right: #{word_filters[0].class}"
      end
    end
  end
end
