# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryHashService do
  subject { described_class.new dictionary_words }

  before do
    LittleWeasel.configure { |_config| }
  end

  let(:dictionary_words) { %w(gene angelo was here) }

  #new
  describe '#new' do
    context 'with a valid dictionary words Array' do
      it 'instantiates without error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with an invalid dictionary words Array' do
      context 'when nil' do
        let(:dictionary_words) {}

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context 'when not an Array' do
        let(:dictionary_words) { :not_an_array }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end

  #execute
  describe '#execute' do
    let(:returned_hash) { subject.execute }

    it 'returns a Hash' do
      expect(returned_hash).to be_kind_of LittleWeasel::DictionaryWordsHash
    end

    describe 'returned Hash' do
      it 'is searchable' do
        expect(dictionary_words.all? {|word| returned_hash[word] }).to eq true
      end
    end
  end
end
