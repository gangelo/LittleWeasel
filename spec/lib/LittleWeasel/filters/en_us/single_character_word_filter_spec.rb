# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::EnUs::SingleCharacterWordFilter do
  subject { described_class.new }

  # filter_match?
  describe '#filter_match?' do
    let(:word) { 'x' }

    context 'when word single character word' do
      it 'returns true' do
        %w[a A I].each do |number|
          expect(subject.filter_match?(number)).to be true
        end
      end
    end

    context 'when word is NOT a single character word' do
      it 'returns false' do
        expect(subject.filter_match?('X')).to be false
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
