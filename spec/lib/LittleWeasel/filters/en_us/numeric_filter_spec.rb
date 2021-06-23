# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::EnUs::NumericFilter do
  subject { described_class.new }

  #filter_match?
  describe 'filter_match?' do
    context 'when word is a number' do
      it 'returns true' do
        [-1.00, -1, 0, 1, 100, 100.10, 1234_56, +100.00, 1_000_000.00].each do |number|
          expect(subject.filter_match? number).to eq true
        end
      end
    end

    context 'when word is NOT a number' do
      it 'returns false' do
        expect(subject.filter_match? 'a').to eq false
        expect(subject.filter_match? :a).to eq false
        expect(subject.filter_match? Object.new).to eq false
      end
    end

    let(:word) { 1 }

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
