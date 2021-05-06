# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::DictionariesHash do
  include_context 'dictionaries_shared'

  before do
    allow(File).to receive(:exist?).and_return true
  end

  subject { create(:dictionaries_hash, dictionary_hash: dictionary_hash) }
  let(:dictionary_hash) { all_dictionaries_hash }

  #new
  describe '#new' do
    context 'when passing no arguments' do
      it_behaves_like 'an instantiated object'
    end

    context 'when passing a Hash' do
      it_behaves_like 'an instantiated object'

      it 'loads the dictionaries' do
        expect(subject.dictionary_count).to eq dictionary_hash.count
        expect(subject.to_hash).to eq dictionary_hash
      end
    end
  end

  #dictionary_count: tested through #new

  #to_array
  describe '#to_array' do
    it 'returns the dictionaries as an Array' do
      expect(subject.to_array).to eq dictionary_hash.to_a
    end
  end

  #to_hash
  describe '#to_hash' do
    it 'returns the dictionaries as a Hash' do
      expect(subject.to_hash).to eq dictionary_hash
    end
  end

  #merge
  describe '#merge' do
    let(:dictionaries) do
      [create(:language_dictionary, language: :xx, file: language_dictionary_path(language: :xx)),
       create(:language_dictionary, language: :yy, file: language_dictionary_path(language: :yy))]
    end
    let(:new_dictionaries_hash) do
      dictionaries.inject(Hash.new(0)) do |hash, dictionary|
        hash.merge! dictionary.to_hash
      end
    end

    context 'when passing an invalid argument' do
      context 'when passing nil' do
        it 'raises an error' do
          expect { subject.merge }.to raise_error ArgumentError
        end
      end

      context 'when passing a non-Hash' do
        it 'raises an error' do
          expect { subject.merge :bad }.to raise_error TypeError
        end
      end
    end

    context 'when passing a Hash' do
      it 'returns the expected dictionaries as a Hash' do
        expect(subject.merge new_dictionaries_hash).to eq dictionary_hash.merge(new_dictionaries_hash)
      end

      it 'does not alter the internal Hash' do
        subject.merge new_dictionaries_hash
        expect(subject.to_hash).to eq dictionary_hash
      end
    end
  end

  #merge!
  describe '#merge!' do
    let(:dictionaries) do
      [create(:language_dictionary, language: :xx, file: language_dictionary_path(language: :xx)),
       create(:language_dictionary, language: :yy, file: language_dictionary_path(language: :yy))]
    end
    let(:new_dictionaries_hash) do
      dictionaries.inject(Hash.new(0)) do |hash, dictionary|
        hash.merge! dictionary.to_hash
      end
    end

    context 'when passing an invalid argument' do
      context 'when passing nil' do
        it 'raises an error' do
          expect { subject.merge! }.to raise_error ArgumentError
        end
      end

      context 'when passing a non-Hash' do
        it 'raises an error' do
          expect { subject.merge! :bad }.to raise_error TypeError
        end
      end
    end

    context 'when passing a Hash' do
      it 'returns the expected dictionaries as a Hash' do
        expect(subject.merge! new_dictionaries_hash).to eq dictionary_hash.merge(new_dictionaries_hash)
      end

      it 'alters the internal Hash' do
        subject.merge! new_dictionaries_hash
        expect(subject.to_hash).to eq dictionary_hash.merge(new_dictionaries_hash)
      end
    end
  end
end
