# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Dictionaries::LanguageDictionary do
  subject { create(sym_for(described_class), language: language, file: dictionary_file_path) }

  let(:language) { :en }
  let(:region) {}
  let(:tag) {}
  let(:dictionary_file_path) { build_dictionary_path_for(file_name: locale) }
  let(:locale) { language.to_s }
  let(:hash_key) { hash_key_for language, region, tag }

  #new
  describe '#new' do
    it 'does not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  #language
  describe '#language' do
    it 'returns the language' do
      expect(subject.language).to eq language
    end
  end

  #file
  describe '#file' do
    it 'returns the file path' do
      expect(subject.file).to eq dictionary_file_path
    end
  end

  #dictionary?
  describe '#dictionary?' do
    it "returns true because it's a dictionary type" do
      expect(subject.language_dictionary?).to eq true
    end
  end

  #locale
  describe '#locale' do
    it 'returns the locale' do
      expect(subject.locale).to eq locale
    end
  end

  #to_hash
  describe '#to_hash' do
    let(:expected_hash) { { hash_key => dictionary_file_path } }

    it 'returns the hash representation of the dictionary' do
      expect(subject.to_hash).to eq(expected_hash)
    end
  end

  #hash_key
  describe '#hash_key' do
    it_behaves_like '#hash_key returns the expected key'
  end
end
