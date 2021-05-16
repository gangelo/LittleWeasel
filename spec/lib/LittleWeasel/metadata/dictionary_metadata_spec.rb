# frozen_string_literal: true

require 'spec_helper'
require 'observer'

RSpec.describe LittleWeasel::Metadata::DictionaryMetadata do
  subject { described_class.new dictionary }

  let!(:configuration) { LittleWeasel.configure { |_config| }; LittleWeasel.configuration }
  let(:dictionary) do
    {
      'gene' => true,
      'was' => true,
      'here' => true,
    }
  end
  let(:metadata_key) { described_class::METADATA_KEY }

  #new
  describe '#new' do
    context 'with a valid dictionary Hash' do
      let(:expected_hash) { { metadata_key => {} } }

      it 'instantiates without error' do
        expect { subject }.to_not raise_error
      end

      it 'initializes the metadata' do
        expect(subject.dictionary).to a_kind_of Hash
        expect(subject.dictionary.key? metadata_key).to eq true
        expect(subject.to_hash include_root: true).to eq expected_hash
      end
    end

    context 'with an invalid dictionary words Hash' do
      context 'when nil' do
        let(:dictionary) {}

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context 'when not a Hash' do
        let(:dictionary) { :not_an_array }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end

  #refresh!
  describe '#refresh!' do
    it 'notifies observers to refresh' do
      expect(subject).to receive(:notify).with(:refresh!).and_return(subject)
      subject.refresh!
    end

    context 'when the object is already initialized' do
      context 'with correct metadata' do
        before do
          subject.dictionary.merge! expected_hash
          subject.refresh!
        end

        let(:expected_hash) do
          {
            metadata_key =>
              {
                test: :test
              }
          }
        end

        it 'the existing metadata is not wiped out' do
          expect(subject.to_hash(include_root: true)).to eq expected_hash
        end
      end

      context 'with incorrect metadata' do
        before do
          subject.dictionary[metadata_key] = :wrong_type
          subject.refresh!
        end

        let(:expected_hash) { { metadata_key => {} } }

        it 'metadata is re-initialized' do
          expect(subject.to_hash(include_root: true)).to eq expected_hash
        end
      end
    end
  end

  #add_observers
  describe '#add_observers' do
    it 'returns the same object that was called' do
      expect(subject.add_observers).to be subject
    end

    it 'attaches the proper metadata observers' do
      expect(subject.add_observers.count_observers).to eq 1
    end
  end

  #.add_observers
  describe '.add_observers' do
    subject { described_class.add_observers(dictionary) }

    it 'returns a new DictionaryMetadata object' do
      expect(subject).to a_kind_of described_class
    end

    it 'attaches the proper metadata observers' do
      expect(subject.count_observers).to eq 1
    end
  end
end
