# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::Locale, type: :module do
  Locale = described_class

  subject do
    Class.new do
      include LittleWeasel::Modules::Locale

      attr_reader :language, :region

      def initialize(language, region)
        self.language = language
        self.region = region
      end

      private

      attr_writer :language, :region
    end.new(language, region)
  end

  let(:language) { :en }
  let(:region) { :us }
  let(:locale) { Locale.locale_from language: language, region: region }
  let(:expected_locale) { Locale.locale_from language: language, region: region }

  #locale
  context '#locale' do
    context 'when language is defined' do
      let(:region) {}

      it 'returns the expected locale' do
        expect(subject.locale).to eq expected_locale
      end
    end

    context 'when language and reagion are defined' do
      it 'returns the expected locale' do
        expect(subject.locale).to eq expected_locale
      end
    end

    context 'when language and reagion are not defined' do
      let(:language) {}
      let(:region) {}

      it 'returns the expected locale' do
        expect { subject.locale }.to raise_error LittleWeasel::Errors::LanguageRequiredError
      end
    end
  end

  #.split_locale
  context '.split_locale' do
    subject { Locale }

    let(:expected_locale) do
      [Locale.language_from(language)].tap do |array|
        array << Locale.region_from(region) if region
      end
    end

    context 'when language is defined' do
      let(:region) {}

      it 'returns the expected locale' do
        expect(subject.split_locale locale).to eq expected_locale
      end
    end

    context 'when language and reagion are defined' do
      it 'returns the expected locale' do
        expect(subject.split_locale locale).to eq expected_locale
      end
    end

    context 'when language and reagion are not defined' do
      let(:language) {}
      let(:region) {}

      it 'returns the expected locale' do
        expect { subject.split_locale locale }.to raise_error LittleWeasel::Errors::LanguageRequiredError
      end
    end
  end

  #.locale_from
  context '.locale_from' do
    subject { Locale }

    let(:language_region_hash) do
      { language: language }.tap do |hash|
        hash[:region] = region if region
      end
    end

    let(:expected_locale) do
      [Locale.language_from(language)].tap do |array|
        array << Locale.region_from(region) if region
      end.join('-')
    end

    context 'when language is defined' do
      let(:region) {}

      it 'returns the expected locale' do
        expect(subject.locale_from **language_region_hash).to eq expected_locale
      end
    end

    context 'when language and reagion are defined' do
      it 'returns the expected locale' do
        expect(subject.locale_from **language_region_hash).to eq expected_locale
      end
    end

    context 'when language and reagion are not defined' do
      let(:language) {}
      let(:region) {}

      it 'returns the expected locale' do
        expect { subject.locale_from **language_region_hash }.to raise_error LittleWeasel::Errors::LanguageRequiredError
      end
    end
  end

  #.language_from
  context 'language_from' do
    context 'when passing a language as a String or Symbol, of any case' do
      let(:languages) { [:en, :EN, 'en', 'EN'] }
      let(:expected_language) { 'en' }

      it 'returns the expected language, lowercase' do
        languages.each do |language|
          expect(Locale.language_from language).to eq expected_language
        end
      end
    end

    context 'when passing nil or an empty string' do
      let(:languages) { [nil, ''] }

      it 'rreturns nil' do
        languages.each do |language|
          expect(Locale.language_from language).to be_nil
        end
      end
    end
  end

  #.region_from
  context 'region_from' do
    context 'when passing a region as a String or Symbol, of any case' do
      let(:regions) { [:us, :US, 'us', 'US'] }
      let(:expected_region) { 'US' }

      it 'returns the expected region, uppercase' do
        regions.each do |region|
          expect(Locale.region_from region).to eq expected_region
        end
      end
    end

    context 'when passing nil or an empty string' do
      let(:regions) { [nil, ''] }

      it 'returns nil' do
        regions.each do |region|
          expect(Locale.region_from region).to be_nil
        end
      end
    end
  end
end
