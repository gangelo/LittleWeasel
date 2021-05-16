# frozen_string_literal: true

require 'spec_helper'
require 'observer'

RSpec.describe LittleWeasel::Metadata::MaxInvalidWordsBytesizeMetadata do
  subject { described_class.new dictionary_metadata }

  let!(:configuration) { LittleWeasel.configure { |_config| }; LittleWeasel.configuration }
  let(:dictionary_metadata) { LittleWeasel::Metadata::DictionaryMetadata.new(dictionary_words_hash) }
  let(:dictionary_words_hash) do
    {
      'gene' => true,
      'was' => true,
      'here' => true,
    }
  end

  #new
  describe '#new' do
    context 'with a valid dictionary words Hash' do
      before do
        dictionary_words_hash['ishcabibble'] = false
      end

      it 'instantiates without error' do
        expect { subject }.to_not raise_error
      end

      it 'initializes the necessary object attributes' do
        expect(subject.on?).to eq true
        expect(subject.off?).to eq false
        expect(subject.value).to eq configuration.max_invalid_words_bytesize
        expect(subject.value_exceeded?).to eq false
        expect(subject.current_invalid_word_bytesize).to eq 11
        expect(subject.cache_invalid_words?).to eq true
      end
    end

    context "with multiple #{described_class.name.split('::')[-1]} objects" do
      context 'when sharing the same dictionary' do
        let(:subject2) { described_class.new dictionary_metadata }
        let(:dictionary_words_hash) do
          {
            'gene' => true,
            'was' => true,
            'here' => true,
            'bad-word10' => false,
          }
        end

        it 'they share the same metadata' do
          expect(subject.dictionary_metadata).to be subject2.dictionary_metadata
          expect(subject.current_invalid_word_bytesize).to eq 10
          expect(subject.current_invalid_word_bytesize).to eq subject2.current_invalid_word_bytesize
          dictionary_metadata.dictionary['bad-word02'] = false
          dictionary_metadata.refresh!
          expect(subject.current_invalid_word_bytesize).to eq 20
          expect(subject.current_invalid_word_bytesize).to eq subject2.current_invalid_word_bytesize
        end
      end
    end

    context 'with an invalid dictionary words Hash' do
      context 'when nil' do
        let(:dictionary_words_hash) {}

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context 'when not a Hash' do
        let(:dictionary_words_hash) { :not_an_array }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end

  #refresh!
  describe '#refresh!' do
    it 'the metadata is refreshed' do
      expect do
        subject.dictionary_metadata.dictionary['not-found'] = false
        subject.refresh!
      end.to change { subject.current_invalid_word_bytesize }
      .from(0).to(9)
    end
  end

  #to_hash
  describe '#to_hash' do
    context 'with the default argument value' do
      let(:expected_hash) do
        {
          described_class::METADATA_KEY => subject
        }
      end

      it 'returns the expected Hash' do
        expect(subject.to_hash).to eq expected_hash
      end
    end

    context 'with argument include_root: true' do
      let(:expected_hash) do
        {
          LittleWeasel::Metadata::DictionaryMetadata::METADATA_KEY =>
            {
              described_class::METADATA_KEY => subject
            }
        }
      end

      it 'returns the expected Hash with the root' do
        expect(subject.to_hash include_root: true).to eq expected_hash
      end
    end
  end

  #Update
  describe '#update' do
    context 'with an action NOT on the whitelist' do
      it 'raises an error' do
        expect { subject.update(:bad_bad_action!) }.to raise_error ArgumentError
      end
    end

    context 'with an action on the whitelist' do
      it 'carries out the requested action' do
        expect do
          dictionary_words_hash['not-found'] = false
          subject.update(:refresh!)
        end.to change { subject.current_invalid_word_bytesize }
        .from(0).to(9)
      end
    end
  end
end
