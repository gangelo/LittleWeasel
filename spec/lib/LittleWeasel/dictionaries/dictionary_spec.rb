# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Dictionaries::Dictionary do
  subject { create(sym_for(described_class), file: dictionary_file_path) }

  let(:language) { :en }
  let(:region) { :us }
  let(:locale) { "#{language.downcase}-#{region.upcase}" }
  let(:tag) {}
  let(:dictionary_file_path) { build_dictionary_path_for file_name: locale }
  let(:hash_key) { hash_key_for language, region, tag }

  #new
  describe '#new' do
    context 'when passing an invalid file' do
      let(:dictionary_file_path) { language_dictionary_path(language: :bad) }

      it 'raise an error' do
        expect{ subject }.to raise_error(/Argument file \(#{dictionary_file_path}\) does not exist/)
      end
    end

    context 'when passing a valid file' do
      it 'the object is instantiated' do
        expect { subject }.not_to raise_error
      end
    end
  end

  #to_hash
  describe '#to_hash' do
    subject { create(sym_for(described_class), file: dictionary_file_path) }

    let(:dictionary_file_path) { build_dictionary_path_for file_name: locale }

    before do
      allow(subject).to receive(:locale).and_return locale
    end

    it 'returns the expected Hash' do
      expect(subject.to_hash).to eq({ hash_key => dictionary_file_path })
    end
  end

  #hash_key
  describe '#hash_key' do
    it_behaves_like '#hash_key returns the expected key'
  end
end
