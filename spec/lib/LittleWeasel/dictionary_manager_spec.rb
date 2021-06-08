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
    subject.reset!
  end

  #.new
  describe '.new' do
    it 'does not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  #add_dictionary_reference
  describe '#add_dictionary_reference' do
    it 'adds the dictionary reference' do
      expect { subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file) }.to_not raise_error
    end
  end

  #load_dictionary
  describe '#load_dictionary' do
    before do
      subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
    end

    let(:tag) { :tagged }

    it 'loads the dictionary and returns a dictionary object' do
      expect(subject.load_dictionary(dictionary_key: dictionary_key)).to be_kind_of LittleWeasel::Dictionary
    end
  end

  #unload_dictionary
  describe '#unload_dictionary' do
    before do
      subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
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
      subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
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
