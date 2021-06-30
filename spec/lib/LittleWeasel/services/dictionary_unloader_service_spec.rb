# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryUnloaderService do
  subject { create(:dictionary_unloader_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:key) { dictionary_key.key }
  let(:file) { "#{ dictionary_path_for(file_name: key) }" }
  let(:dictionary_cache) { {} }

  #execute
  describe '#execute' do
    context 'when unloading dictionaries created from a file' do
      let(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_file_source: dictionary_key.key, load: true) }
      let!(:unloaded_dictionary_object) { dictionary_cache_service.dictionary_object! }

      it 'unloads the dictionary from the dictionary cache and returns the unloaded dictionary object' do
        expect(dictionary_cache_service.dictionary_loaded?).to be true
        expect(subject.execute).to be unloaded_dictionary_object
        expect(dictionary_cache_service.dictionary_loaded?).to be false
      end
    end

    context 'when unloading dictionaries created from memory' do
      it 'does something'
    end
  end
end
