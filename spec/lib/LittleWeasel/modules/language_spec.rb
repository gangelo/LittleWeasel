# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::Language, type: :module do
  Language = described_class

  subject do
    Class.new do
      include Language

      attr_reader :language

      def initialize(language)
        self.language = language
      end

      private

      attr_writer :language
    end.new(language)
  end

  let(:language) {}

  #normalize_language
  describe '#normalize_language' do
    context 'with a non-nil language' do
      context 'when passing a Symbol' do
        let(:language) { :AbCdEfG }

        it 'converts the language to a lower-case Symbol' do
          expect(subject.normalize_language).to eq :abcdefg
        end
      end

      context 'when passing a String' do
        let(:language) { 'AbCdEfG' }

        it 'converts the language to a lower-case String' do
          expect(subject.normalize_language).to eq 'abcdefg'
        end
      end
    end

    context 'with a nil language' do
      it 'returns nil' do
        expect(subject.normalize_language).to be_nil
      end
    end
  end
end
