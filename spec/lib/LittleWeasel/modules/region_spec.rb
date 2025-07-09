# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::Region, type: :module do
  Region = described_class

  subject do
    Class.new do
      include Region

      attr_reader :region

      def initialize(region)
        self.region = region
      end

      private

      attr_writer :region
    end.new(region)
  end

  let(:region) {}

  # region?
  describe '#region?' do
    context 'when region is present?' do
      let(:region) { :es }

      it 'returns true' do
        expect(subject.region?).to be true
      end
    end

    context 'when region is NOT present?' do
      it 'returns false' do
        expect(subject.region?).to be false
      end
    end
  end

  # normalize_region!
  describe '#normalize_region!' do
    context 'when region is present?' do
      context 'when region responds to #upcase' do
        before do
          subject.normalize_region!
        end

        let(:region) { :aa }

        it 'changes region to upper case' do
          expect(subject.region).to eq :AA
        end
      end

      context 'when region DOES NOT respond to #upcase' do
        let(:region) { Object.new }

        it 'raises an error' do
          expect { subject.normalize_region! }.to raise_error(NoMethodError, /undefined method [`|']upcase'/)
        end
      end
    end

    context 'when region is NOT present?' do
      before do
        subject.normalize_region!
      end

      it 'does nothing' do
        expect(subject.region).to be_nil
      end
    end
  end

  # .normalize_region
  describe '#.normalize_region' do
    context 'with a non-nil region' do
      context 'when passing a Symbol' do
        let(:region) { :AbCdEfG }

        it 'converts the region to a upper-case Symbol' do
          expect(described_class.normalize_region(region)).to eq :ABCDEFG
        end
      end

      context 'when passing a String' do
        let(:region) { 'AbCdEfG' }

        it 'converts the region to a upper-case String' do
          expect(described_class.normalize_region(region)).to eq 'ABCDEFG'
        end
      end
    end

    context 'with a nil region' do
      it 'returns nil' do
        expect(described_class.normalize_region(region)).to be_nil
      end
    end

    context 'when region does not respond to #upcase' do
      let(:region) { 1 }

      it 'returns nil' do
        expect { described_class.normalize_region(region) }.to raise_error(NoMethodError, /undefined method [`|']upcase'/)
      end
    end
  end
end
