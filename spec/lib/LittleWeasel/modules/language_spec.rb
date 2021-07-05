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

  #language?
  describe '#language?' do
    context 'when language is present?' do
      let(:language) { :es }

      it 'returns true' do
        expect(subject.language?).to eq true
      end
    end

    context 'when language is NOT present?' do
      it 'returns false' do
        expect(subject.language?).to eq false
      end
    end
  end

  #normalize_language!
  describe '#normalize_language!' do
    context 'when language is present?' do
      context 'when language responds to #upcase!' do
        before do
          subject.normalize_language!
        end

        let(:language) { :AA }

        it 'changes language to lower case' do
          expect(subject.language).to eq :aa
        end
      end

      context 'when language DOES NOT respond to #downcase' do
        let(:language) { Object.new }

        it 'raises an error' do
          expect { subject.normalize_language! }.to raise_error(NoMethodError, /undefined method `downcase'/)
        end
      end
    end

    context 'when language is NOT present?' do
      before do
        subject.normalize_language!
      end

      it 'does nothing' do
        expect(subject.language).to be_nil
      end
    end
  end

  #.normalize_language
  describe '#.normalize_language' do
    context 'with a non-nil language' do
      context 'when passing a Symbol' do
        let(:language) { :AbCdEfG }

        it 'converts the language to a lower-case Symbol' do
          expect(described_class.normalize_language(language)).to eq :abcdefg
        end
      end

      context 'when passing a String' do
        let(:language) { 'AbCdEfG' }

        it 'converts the language to a lower-case String' do
          expect(described_class.normalize_language(language)).to eq 'abcdefg'
        end
      end
    end

    context 'with a nil language' do
      it 'returns nil' do
        expect(described_class.normalize_language(language)).to be_nil
      end
    end

    context 'when language does not respond to #downcase' do
      let(:language) { 1 }

      it 'returns nil' do
        expect { described_class.normalize_language(language) }.to raise_error(NoMethodError, /undefined method `downcase'/)
      end
    end
  end
end
