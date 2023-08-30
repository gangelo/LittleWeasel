# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::EnUs::CurrencyFilter do
  subject { described_class.new }

  # filter_match?
  describe 'filter_match?' do
    let(:word) { 1 }

    context 'when word is currency' do
      it 'returns true' do
        expect(subject.filter_match?('-$1.00')).to be true
        expect(subject.filter_match?('-$1')).to be true
        expect(subject.filter_match?('$0')).to be true
        expect(subject.filter_match?('$1')).to be true
        expect(subject.filter_match?('$100')).to be true
        expect(subject.filter_match?('$100.10')).to be true
        expect(subject.filter_match?('$123456')).to be true
        expect(subject.filter_match?('+$110.09')).to be true
        expect(subject.filter_match?('-$1,000.09')).to be true
        expect(subject.filter_match?('$1000000.00')).to be true
        expect(subject.filter_match?('$1100000.10')).to be true
        expect(subject.filter_match?('$120000.01')).to be true
        expect(subject.filter_match?('$1,000,000.01')).to be true
      end
    end

    context 'when word has decimals, but not 2 decimal places' do
      it 'returns false' do
        expect(subject.filter_match?('-$1.1')).to be false
        expect(subject.filter_match?('$0.1')).to be false
        expect(subject.filter_match?('$100.9')).to be false
        expect(subject.filter_match?('+$100.2')).to be false
        expect(subject.filter_match?('$1000000.0')).to be false
        expect(subject.filter_match?('$1000000.1')).to be false
        expect(subject.filter_match?('$1000000.5')).to be false
      end
    end

    context 'when word is NOT currency' do
      it 'returns false' do
        expect(subject.filter_match?('a')).to be false
        expect(subject.filter_match?(:a)).to be false
        expect(subject.filter_match?(Object.new)).to be false
      end
    end

    context 'when #filter_match? returns true' do
      before { allow(subject.class).to receive(:filter_match?).and_return(true) }

      context 'when #filter_on? is true' do
        it_behaves_like 'the filter matches and #filter_on? is true'
      end

      context 'when #filter_on? is false' do
        before do
          subject.filter_on = false
        end

        it_behaves_like 'the filter matches and #filter_on? is false'
      end
    end

    context 'when #filter_match? returns false' do
      before { allow(subject.class).to receive(:filter_match?).and_return(false) }

      context 'when #filter_on? is true' do
        it_behaves_like 'the filter DOES NOT match and #filter_on? is true'
      end

      context 'when #filter_on? is false' do
        let(:filter_on) { false }

        it_behaves_like 'the filter DOES NOT match and #filter_on? is false'
      end
    end
  end
end
