# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::DictionaryManager do
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:file) { dictionary_path_for(file_name: dictionary_key.key) }

  #.instance
  describe '.instance' do
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
      subject.reset!
      subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
      subject.load_dictionary(dictionary_key: dictionary_key)
    end

    xit 'unloads the dictionary but keeps the file reference and metadata in the dictionary cache' do
      subject.unload_dictionary(dictionary_key: dictionary_key)
    end

    xit 'returns the dictionary manager instance' do
      expect(subject.unload_dictionary(dictionary_key: dictionary_key)).to eq subject
    end
  end

  #kill
  describe '#kill_dictionary' do
    before do
      subject.reset!
      subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
      subject.load_dictionary(dictionary_key: dictionary_key)
    end

    xit 'removes the dictionary, file reference and metadata from the dictionary cache' do
      subject.kill_dictionary(dictionary_key: dictionary_key)
    end

    xit 'returns the dictionary manager instance' do
      expect(subject.unload_dictionary(dictionary_key: dictionary_key)).to eq subject
    end
  end
end
