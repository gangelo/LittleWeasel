# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Metadata::DictionaryMetadata do
  subject { create(:dictionary_metadata, dictionary_words: dictionary_words, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata) }

  let!(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_file_source: true, load: true) }
  let!(:dictionary_metadata_service) { create(:dictionary_metadata_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata) }
  let(:dictionary_words) { create(:dictionary_hash) }
  let(:dictionary_key) { create(:dictionary_key) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:invalid_words_metadata_key) { invalid_words_metadata_class.metadata_key }
  let(:invalid_words_metadata_class) { LittleWeasel::Metadata::InvalidWordsMetadata }

  # .new
  describe '#.new' do
    context 'with valid arguments' do
      it 'instantiates the object' do
        expect { subject }.not_to raise_error
      end
    end

    context 'with invalid arguments' do
      context 'when dictionary_words is nil' do
        # NOTE: do not use the factory for this spec becasue
        # it creates a dictionary if a nil dictionay is passed
        # so the test will never pass if using the factory.
        subject { described_class.new(dictionary_words: dictionary_words, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata) }

        let(:dictionary_words) {}

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument dictionary_words is not a Hash/)
        end
      end

      context 'when dictionary_words is not a Hash' do
        let(:dictionary_words) { %w[I am a bad dictionary] }

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument dictionary_words is not a Hash/)
        end
      end
    end
  end

  # []
  describe '#[]' do
    context 'when passing a valid metadata_key' do
      context 'when it is a key that points to a valid metadata observer' do
        before do
          subject.add_observers
        end

        it 'returns the metadata observer object' do
          expect(subject[invalid_words_metadata_key]).to be_a invalid_words_metadata_class
        end
      end

      context 'when it is a key that DOES NOT point to a valid metadata observer' do
        it 'returns nil' do
          expect(subject[invalid_words_metadata_key]).to be_nil
        end
      end
    end

    context 'when passing an INVALID metadata_key' do
      it 'returns nil' do
        expect(subject[:bad_metadata_key]).to be_nil
      end
    end
  end

  # init
  describe '#init' do
    context 'when there are observers attached' do
      before do
        subject.add_observers
      end

      context 'when metadata is in the dictionary cache' do
        it 'observers are notified to init' do
          # Sanity check.
          expect(subject.count_observers).to eq 1
          expect(subject.observers[invalid_words_metadata_key]).to receive(:init)
          subject.init
        end
      end
    end

    context 'when there are NO observers attached' do
      it 'observers are NOT notified to init' do
        # Sanity check.
        expect(subject.count_observers).to eq 0
        expect(subject.observers[invalid_words_metadata_key]).not_to receive(:init)
        subject.init
      end
    end

    context 'when dictionary metadata is already in the dictionary cache' do
      it 'inits the metadata with what is currently in the dictionary cache' do
      end
    end
  end

  # refresh
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
      it 'observers are NOT notified to refresh' do
        # Sanity check.
        expect(subject.count_observers).to eq 0
        expect(subject.observers[invalid_words_metadata_key]).not_to receive(:refresh)
        subject.refresh
      end
    end

    context 'when dictionary metadata is already in the dictionary cache' do
      it 'refreshes the metadata with what is currently in the dictionary cache' do
      end
    end
  end

  # delete_observer
  describe '#delete_observer' do
    context 'when a valid observer object is passed' do
      before do
        subject.add_observers
      end

      let(:observer) { subject.observers.values.first }

      it 'the observer is removed from the #observers list' do
        expect { subject.delete_observer(observer) }
          .to change { subject.observers.count }
          .from(1)
          .to(0)
      end
    end

    context 'when an INVALID observer object is passed' do
      let(:bad_observer) { :bad_observer }

      it 'raises an error' do
        expect { subject.delete_observer(bad_observer) }.to raise_error 'Argument metadata_observable is not a ' \
                                                                        "Metadata::MetadataObserverable object: #{bad_observer.class}"
      end
    end
  end

  # add_observers
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
        allow(LittleWeasel::Metadata::InvalidWordsMetadata).to receive(:observe?).and_return(false)
      end

      it 'NOT added as an observer' do
        expect(subject.add_observers.count_observers).to eq 0
      end
    end
  end
end
