# frozen_string_literal: true

require 'spec_helper'
require 'observer'

RSpec.describe LittleWeasel::Metadata::DictionaryMetadata do
  subject { create(:dictionary_metadata, dictionary_words: dictionary_words, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata) }

  let!(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: true, load: true) }

  let(:dictionary_words) { create(:dictionary_hash) }
  let(:dictionary_key) { create(:dictionary_key) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:invalid_words_metadata_key) { LittleWeasel::Metadata::InvalidWords::InvalidWordsMetadata.metadata_key }

  #.new
  describe '#.new' do
    context 'with valid arguments' do
      it 'instantiates the object' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with invalid arguments' do
      context 'when dictionary_words is nil' do
        # Note: do not use the factory for this spec becasue
        # it creates a dictionary if a nil dictionay is passed
        # so the test will never pass if using the factory.
        subject { described_class.new(dictionary_words: dictionary_words, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata) }

        let(:dictionary_words) {}

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument dictionary_words is not a Hash/)
        end
      end

      context 'when dictionary_words is not a Hash' do
        let(:dictionary_words) { %w(I am a bad dictionary) }

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument dictionary_words is not a Hash/)
        end
      end
    end
  end

  #refresh
  describe '#refresh' do
    context 'when there are observers attached' do
      before do
        subject.add_observers
      end

      it 'observers are notified to refresh' do
        # Sanity check.
        expect(subject.count_observers).to eq 1
        expect(subject.observers[invalid_words_metadata_key]).to receive(:refresh)
        subject.refresh
      end
    end

    context 'when there are NO observers attached' do
      it 'observers are NOT norified to refresh' do
        # Sanity check.
        expect(subject.count_observers).to eq 0
        expect(subject.observers[invalid_words_metadata_key]).to_not receive(:refresh)
        subject.refresh
      end
    end

    context 'when dictionary metadata is already in the dictionary cache' do
      it 'refreshes the metadata with what is currently in the dictionary cache' do
      end
    end
  end

  #add_observers
  describe '#add_observers' do
    it 'returns the same object that was called' do
      expect(subject.add_observers).to be subject
    end

    context 'when a metadata object is in a state to observe' do
      it 'added as an observer' do
        expect(subject.add_observers.count_observers).to eq 1
      end

      context 'when #add_observers is called more than once' do
        context 'when argument force is true (force: true)' do
          before do
            subject.add_observers
          end

          it 'reinstantiates and replaces the observers' do
            expect(subject.add_observers(force: true).count_observers).to eq 1
          end
        end

        context 'when argument force is false (force: false)' do
          before do
            subject.add_observers
          end

          it 'raises an error' do
            expect { subject.add_observers }.to raise_error 'Observers have already been added; use #add_observers(force: true) instead'
          end
        end
      end
    end

    context 'when a metadata object is NOT in a state to observe' do
      before do
        allow(LittleWeasel::Metadata::InvalidWords::InvalidWordsMetadata).to receive(:observe?).and_return(false)
      end

      it 'NOT added as an observer' do
        expect(subject.add_observers.count_observers).to eq 0
      end
    end
  end
end
