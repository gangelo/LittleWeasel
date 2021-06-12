# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::WordFilterValidatable, type: :module do
  WordFilterValidatable = described_class

  subject do
    Class.new do
      include WordFilterValidatable
    end.new
  end

  let(:word_filters) do
    word_filters = []
    word_filters << numeric_filter
    word_filters
  end
  let(:numeric_filter) { LittleWeasel::Filters::NumericFilter.new filter_on: filter_on }
  let(:filter_on) { true }

  #validate_word_filter
  describe '#validate_word_filter' do
    context 'when word_filter is valid' do
      expect(subject.validate_word_filter(word_filter: numeric_filter)).to eq true
    end
  end
end
