# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryLoaderService do
  subject { create(:dictionary_loader_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata) }

  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }

  #execute
  describe '#execute' do
    let!(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_reference: true, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

    context 'when the dictionary is not cached' do
      it 'loads the dictionary file and returns the Dictionary' do
        expect(dictionary_cache_service.dictionary_cached?).to be false
        expect(subject).to_not receive(:load_from_cache)
        expect(subject.execute).to be_kind_of LittleWeasel::Dictionary
      end
    end

    context 'when the dictionary is cached' do
      before do
        # This will load the dictionary from disk, and cache it in
        # the dictionary cache - the DictionaryLoaderService does not
        # add the loaded dictionary into the dictionary cache, so, we
        # have to do it manually here.
        dictionary_cache_service.dictionary_object = subject.execute
      end

      it 'loads the dictionary from the dictionary cache and returns the Dictionary' do
        expect(dictionary_cache_service.dictionary_cached?).to be true
        expect(subject).to receive(:load_from_cache).and_return(dictionary_cache_service.dictionary_object!)
        expect(subject.execute).to be dictionary_cache_service.dictionary_object!
      end
    end
  end
end
