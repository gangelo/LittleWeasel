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

  #normalize_region
  describe '#normalize_region' do
    context 'with a non-nil region' do
      context 'when passing a Symbol' do
        let(:region) { :AbCdEfG }

        it 'converts the region to a upper-case Symbol' do
          expect(subject.normalize_region).to eq :ABCDEFG
        end
      end

      context 'when passing a String' do
        let(:region) { 'AbCdEfG' }

        it 'converts the region to a upper-case String' do
          expect(subject.normalize_region).to eq 'ABCDEFG'
        end
      end
    end

    context 'with a nil region' do
      it 'returns nil' do
        expect(subject.normalize_region).to be_nil
      end
    end
  end
end
