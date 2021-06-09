# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::DictionaryKey, type: :class do
  subject { described_class.new(language: language, region: region, tag: tag) }

  let(:language) {}
  let(:region) {}
  let(:tag) {}

  #.new
  describe '.new' do
    context 'when passing valid arguments' do
      let(:language) { :EN }
      let(:region) { :us }
      let(:tag) { :TAGGED}

      it 'instantiates the object' do
        expect { subject }.to_not raise_error
      end

      it 'normalizes language and converts it to lowercase' do
        expect(subject.language).to eq :en
      end

      it 'normalizes region and converts it to uppercase' do
        expect(subject.region).to eq :US
      end

      it 'leaves tag case unchanged' do
        expect(subject.tag).to eq :TAGGED
      end
    end

    context 'when passing invalid arguments' do
      context 'when passing an invalid language' do
        it 'raises an error' do
          expect { subject }.to raise_error 'Argument language is not a Symbol'
        end
      end

      context 'when passing an invalid region' do
        let(:language) { :en }
        let(:region) { 1 }

        it 'raises an error' do
          expect { subject }.to raise_error 'Argument region is not a Symbol'
        end
      end
    end
  end

  #.key
  describe '.key' do
    let(:language) { :xx }
    let(:region) { :yy }
    let(:tag) { :zz }

    it 'returns the locale' do
      expect(described_class.key language: language, region: region, tag: tag).to eq 'xx-YY-zz'
    end
  end

  #key
  describe '#key' do
    context 'with no tag' do
      context 'with language' do
        let(:language) { :EN }

        it 'returns the key in the form of a locale String that includes language only (e.g. "en")' do
          expect(subject.key).to eq 'en'
        end
      end

      context 'with language and region' do
        let(:language) { :EN }
        let(:region) { :us }

        it 'returns the key in the form of a locale String that includes language and region  (e.g. "en-US")' do
          expect(subject.key).to eq 'en-US'
        end
      end
    end

    context 'with a tag' do
      let(:tag) { :tagged }

      context 'with language and a tag' do
        let(:language) { :EN }

        it 'returns the key in the form of a locale String that includes the language and appended tag (e.g. "en-tag")' do
          expect(subject.key).to eq 'en-tagged'
        end
      end

      context 'with language and region' do
        let(:language) { :EN }
        let(:region) { :us }

        it 'returns the key in the form of a locale String that includes language, region and the appended tag  (e.g. "en-US-tag")' do
          expect(subject.key).to eq 'en-US-tagged'
        end
      end
    end
  end

  #to_s
  describe '#to_s' do
    let(:language) { :en }
    let(:region) { :us }
    let(:tag) { :tagged }

    it '#to_s is an alias for #key' do
      expect(subject.to_s).to eq 'en-US-tagged'
    end
  end
end
