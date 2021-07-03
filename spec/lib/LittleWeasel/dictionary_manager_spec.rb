# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::DictionaryManager do
  subject { create(:dictionary_manager) }

  let(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache)}
  let(:dictionary_metadata_service) { create(:dictionary_metadata_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata)}
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:dictionary_cache) { subject.dictionary_cache }
  let(:dictionary_metadata) { subject.dictionary_metadata }

  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:file) { dictionary_path_for(file_name: dictionary_key.key) }

  let(:metadata_key) do
    dictionary_cache_service.dictionary_object.dictionary_metadata_object.observers.keys.first
  end

  before(:each) do
    subject.init
  end

  #.new
  describe '.new' do
    it 'does not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  #create_dictionary_from_file
  describe '#create_dictionary_from_file' do
    context 'when the dictionary DOES NOT exist' do
      it 'creates a dictionary and returns a dictionary object' do
        expect(subject.create_dictionary_from_file(dictionary_key: dictionary_key, file: file)).to be_kind_of LittleWeasel::Dictionary
      end
    end

    context 'when the dictionary already exists' do
      before do
        subject.create_dictionary_from_file(dictionary_key: dictionary_key, file: file)
      end

      it 'raises an error' do
        expect { subject.create_dictionary_from_file(dictionary_key: dictionary_key, file: file) }
          .to raise_error("The dictionary source associated with key '#{dictionary_key.key}' already exists.")
      end
    end
  end

  #create_dictionary_from_memory
  describe '#create_dictionary_from_memory' do
    let(:dictionary_words) { dictionary_words_for(dictionary_file_path: file) }

    context 'when the dictionary reference does not exist and the dictionary is not cached' do
      it 'adds a dictionary reference caches the dictionary and returns a dictionary object' do
        expect(subject.create_dictionary_from_memory(dictionary_key: dictionary_key, dictionary_words: dictionary_words)).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary_cache_service.dictionary_reference?).to eq true
        expect(dictionary_cache_service.dictionary_object?).to eq true
      end
    end

    context 'when the dictionary reference exists' do
      before do
        subject.create_dictionary_from_memory(dictionary_key: dictionary_key, dictionary_words: dictionary_words)
      end

      it 'raises an error' do
        expect { subject.create_dictionary_from_memory(dictionary_key: dictionary_key, dictionary_words: dictionary_words) }
          .to raise_error "The dictionary source associated with key '#{dictionary_key.key}' already exists."
      end
    end
  end

  #kill
  describe '#kill_dictionary' do
    context 'dictionaries created from files' do
      before do
        subject.create_dictionary_from_file(dictionary_key: dictionary_key, file: file)
      end

      it 'removes the dictionary, file source reference and metadata from the dictionary cache' do
        metadata_key # Capture this before we unload the dictionary
        subject.kill_dictionary(dictionary_key: dictionary_key)
        expect(dictionary_cache_service.dictionary_exists?).to eq false
        expect(dictionary_cache_service.dictionary_reference?).to eq false
        expect(dictionary_metadata_service.dictionary_metadata?(metadata_key: metadata_key)).to eq false
      end

      it 'returns the dictionary manager instance' do
        expect(subject.kill_dictionary(dictionary_key: dictionary_key)).to eq subject
      end
    end

    context 'dictionaries created from memory' do
      before do
        subject.create_dictionary_from_memory(dictionary_key: dictionary_key, dictionary_words: %w(Abel Cain Deborah Elijah))
      end

      it 'removes the dictionary, memory source reference and metadata from the dictionary cache' do
        metadata_key # Capture this before we unload the dictionary
        subject.kill_dictionary(dictionary_key: dictionary_key)
        expect(dictionary_cache_service.dictionary_exists?).to eq false
        expect(dictionary_cache_service.dictionary_reference?).to eq false
        expect(dictionary_metadata_service.dictionary_metadata?(metadata_key: metadata_key)).to eq false
      end

      it 'returns the dictionary manager instance' do
        expect(subject.kill_dictionary(dictionary_key: dictionary_key)).to eq subject
      end
    end
  end
end
