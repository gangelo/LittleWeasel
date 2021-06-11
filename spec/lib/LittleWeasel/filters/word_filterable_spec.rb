# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::WordFilterable do
  subject { described_class.new filter_on: filter_on }

  let(:filter_on) { true }

  #.new
  describe '.new' do
    context 'sets #filter_on' do
      context 'when true is passed' do
        let(:filter_on) { true }

        it 'sets #filter_on to true' do
          expect(subject.filter_on).to eq true
        end
      end

      context 'when false is passed' do
        let(:filter_on) { false }

        it 'sets #filter_on to false' do
          expect(subject.filter_on).to eq false
        end
      end
    end

    context 'when argument filter_on is valid' do
      context 'when true' do
        it 'instantiates the object' do
          expect { subject }.to_not raise_error
        end
      end

      context 'when false' do
        let(:filter_on) { false }

        it 'instantiates the object' do
          expect { subject }.to_not raise_error
        end
      end
    end

    context 'when argument filter_on is INVALID' do
      context 'when argument filter_on is not true or false' do
        let(:filter_on) { :not_true_or_false }

        it 'raises an error' do
          expect { subject.new filter_on: filter_on }.to raise_error "Argument filter_on is not true or false: #{filter_on}"
        end
      end
    end
  end

  #filter_on
  describe '#filter_on' do
    context 'when set to true' do
      before do
        subject.filter_on = true
      end

      it 'returns true' do
        expect(subject.filter_on).to eq true
      end
    end

    context 'when set to false' do
      before do
        subject.filter_on = false
      end

      it 'returns false' do
        expect(subject.filter_on).to eq false
      end
    end
  end

  #filter_on?
  describe '#filter_on?' do
    context 'when #filter_on is true' do
      it 'returns true' do
        expect(subject.filter_on?).to eq true
      end
    end

    context 'when #filter_on is false' do
      let(:filter_on) { false }

      it 'returns false' do
        expect(subject.filter_on?).to eq false
      end
    end
  end

  #filter_match?
  describe '#filter_match?' do
    let(:word) { 'word' }

    context 'when not overridden' do
      it 'raises an error' do
        expect { subject.filter_match? 'boom' }.to raise_error LittleWeasel::Errors::MustOverrideError
      end
    end

    context 'when #filter_match? returns true' do
      before { allow(subject.class).to receive(:filter_match?).and_return(true) }

      context 'when #filter_on? is true' do
        it_behaves_like 'the filter matches and #filter_on? is true'
      end

      context 'when #filter_on? is false' do
        let(:filter_on) { false }

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
