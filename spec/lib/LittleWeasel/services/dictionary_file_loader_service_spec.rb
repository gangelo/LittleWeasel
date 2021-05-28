# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryFileLoaderService do
  include_context 'dictionary cache'

  subject do
    dictionary_cache_service.init! dictionary_cache
    described_class.new dictionary_key: dictionary_key, dictionary_cache: dictionary_cache
  end

  before(:each) do
    subject
  end

  before { LittleWeasel.configure { |_config| } }

  let(:dictionary_cache_service) { LittleWeasel::Services::DictionaryCacheService }
  let(:dictionary_key) { LittleWeasel::Dictionaries::DictionaryKey.new(language: :en, region: :us) }
  let(:key) {  dictionary_key.key }
  let(:file) { dictionary_path_for locale: dictionary_key.locale }
  let(:dictionary_file_key) { file }
  let(:dictionary_cache) { {} }

  #execute
  describe '#execute' do
    context 'when the dictionary is already loaded/cached' do
      before do
        dictionary_cache_service.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache).add_dictionary_reference file: file
        dictionary_cache[DICTIONARY_CACHE][dictionary_file_key][DICTIONARY_OBJECT] = { dummy_dictionary_cached: true }
      end

      it 'raises an error' do
        expect { subject.execute }.to raise_error "The Dictionary associated with argument key '#{key}' has been loaded and cached; load it from the cache instead."
      end
    end

    context 'when the dictionary is NOT already loaded/cached' do
      before do
        dictionary_cache_service.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache).add_dictionary_reference file: file
      end

      it_behaves_like 'the dictionary was loaded'
    end
  end
end
