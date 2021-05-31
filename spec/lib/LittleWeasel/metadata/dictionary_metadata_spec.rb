# frozen_string_literal: true

require 'spec_helper'
require 'observer'

RSpec.describe LittleWeasel::Metadata::DictionaryMetadata do
  subject { create(:dictionary_metadata, dictionary: dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

  before do
    LittleWeasel.configure { |_config| }
    create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: true, load: true)
  end

  let(:dictionary) { create(:dictionary_hash) }
  let(:dictionary_key) { create(:dictionary_key) }
  let(:dictionary_cache) { {} }

  #.new
  describe '#.new' do
    context 'with valid arguments' do
      it 'instantiates the object' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with invalid arguments' do
      context 'when dictionary is nil' do
        # Note: do not use the factory for this spec becasue
        # it creates a dictionary if a nil dictionay is passed
        # so the test will never pass if using the factory.
        subject { described_class.new(dictionary: dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

        let(:dictionary) {}

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument dictionary is not a Hash/)
        end
      end

      context 'when dictionary is not a Hash' do
        let(:dictionary) { %w(I am a bad dictionary) }

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument dictionary is not a Hash/)
        end
      end
    end
  end

  #refresh!
  describe '#refresh!' do
    it 'notifies observers to refresh'

    context 'when the object is already initialized' do
      context 'with correct metadata' do
        it 'the existing metadata is not wiped out'
      end

      context 'with incorrect metadata' do
        it 'metadata is re-initialized'
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
  # describe '.add_observers' do
  #   subject { described_class.add_observers(dictionary: dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

  #   it 'returns a new DictionaryMetadata object' do
  #     expect(subject).to a_kind_of described_class
  #   end

  #   it 'attaches the proper metadata observers' do
  #     expect(subject.count_observers).to eq 1
  #   end
  # end
end
