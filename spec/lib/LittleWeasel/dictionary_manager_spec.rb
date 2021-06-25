# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::DictionaryManager do
  subject { create(:dictionary_manager) }

  let(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: subject.dictionary_cache)}
  let(:dictionary_metadata_service) { create(:dictionary_metadata_service, dictionary_key: dictionary_key, dictionary_cache: subject.dictionary_cache, dictionary_metadata: dictionary_metadata)}
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

  #add_dictionary_file_source
  describe '#add_dictionary_file_source' do
    it 'adds the dictionary reference' do
      expect { subject.add_dictionary_file_source(dictionary_key: dictionary_key, file: file) }.to_not raise_error
    end
  end

  #load_dictionary
  describe '#load_dictionary' do
    before do
      subject.add_dictionary_file_source(dictionary_key: dictionary_key, file: file)
    end

    let(:tag) { :tagged }

    it 'loads the dictionary and returns a dictionary object' do
      expect(subject.load_dictionary(dictionary_key: dictionary_key)).to be_kind_of LittleWeasel::Dictionary
    end
  end

  #create_dictionary_from_file
  describe '#create_dictionary_from_file' do
    context 'when the dictionary reference does not exist and the dictionary is not loaded/cached' do
      it 'adds a dictionary reference, loads/caches the dictionary and returns a dictionary object' do
        expect(subject.create_dictionary_from_file(dictionary_key: dictionary_key, file: file)).to be_kind_of LittleWeasel::Dictionary
        expect(dictionary_cache_service.dictionary_reference?).to eq true
        expect(dictionary_cache_service.dictionary_object?).to eq true
      end
    end

    context 'when the dictionary reference exists' do
      before do
        subject.add_dictionary_file_source(dictionary_key: dictionary_key, file: file)
      end

      it 'raises an error' do
        expect { subject.create_dictionary_from_file(dictionary_key: dictionary_key, file: file) }.to raise_error "Dictionary reference for key '#{dictionary_key.key}' already exists."
      end
    end
  end

  #unload_dictionary
  describe '#unload_dictionary' do
    before do
      subject.add_dictionary_file_source(dictionary_key: dictionary_key, file: file)
      subject.load_dictionary(dictionary_key: dictionary_key)
    end

    it 'unloads the dictionary but keeps the file reference and metadata in the dictionary cache' do
      metadata_key # Capture this before we unload the dictionary
      subject.unload_dictionary(dictionary_key: dictionary_key)
      expect(dictionary_cache_service.dictionary_loaded?).to eq false
      expect(dictionary_cache_service.dictionary_reference?).to eq true
      expect(dictionary_metadata_service.dictionary_metadata?(metadata_key: metadata_key)).to eq true
   end

    it 'returns the dictionary manager object' do
      expect(subject.unload_dictionary(dictionary_key: dictionary_key)).to eq subject
    end
  end

  #kill
  describe '#kill_dictionary' do
    before do
      subject.add_dictionary_file_source(dictionary_key: dictionary_key, file: file)
      subject.load_dictionary(dictionary_key: dictionary_key)
    end

    it 'removes the dictionary, file reference and metadata from the dictionary cache' do
      metadata_key # Capture this before we unload the dictionary
      subject.kill_dictionary(dictionary_key: dictionary_key)
      expect(dictionary_cache_service.dictionary_loaded?).to eq false
      expect(dictionary_cache_service.dictionary_reference?).to eq false
      expect(dictionary_metadata_service.dictionary_metadata?(metadata_key: metadata_key)).to eq false
    end

    it 'returns the dictionary manager instance' do
      expect(subject.kill_dictionary(dictionary_key: dictionary_key)).to eq subject
    end
  end
end
