# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryMetadataService do
  include_context 'dictionary cache'
  include_context 'dictionary keys'

  subject { create(:dictionary_metadata_service, dictionary_key: dictionary_key, dictionary_metadata: dictionary_metadata, dictionary_cache: dictionary_cache) }

  let(:en_us_dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:en_gb_dictionary_key) { dictionary_key_for(language: :en, region: :gb) }
  let(:es_es_dictionary_key) { dictionary_key_for(language: :es, region: :es) }

  let(:dictionary_key) { en_us_dictionary_key }
  let(:key) { dictionary_key.key }
  let(:file) { "#{ dictionary_path_for(file_name: key) }" }
  let(:dictionary_cache) { {} }
  let!(:initialized_dictionary_cache) { {} }
  let(:metadata_key) { :metadata_key }
  let(:dictionary_metadata) do
    {
      0 => { metadata_key => :metadata_object },
      1 => { metadata_key0: :metadata_object0 }
    }
  end

  shared_examples 'the dictionary_metadata object reference has not changed' do
    it 'the dictionary_metadata object has not changed' do
      expect(actual_dictionary_metadata).to be expected_dictionary_metadata
    end
  end

  shared_examples 'the dictionary_cache object reference has not changed' do
    it 'the dictionary_cache object has not changed' do
      expect(actual_dictionary_cache).to be expected_dictionary_cache
    end
  end

  describe 'class methods' do
    #.reset!
    describe '.reset!' do
    end

    #.init!
    describe '.init!' do
    end
  end

  #.new
  describe '.new' do
    context 'when the arguments are valid' do
      it 'instantiates without errors' do
        expect { subject }.to_not raise_error
      end
    end

    it_behaves_like 'the dictionary_key is invalid'
    it_behaves_like 'the dictionary_cache is invalid'
    it_behaves_like 'the dictionary_metadata is invalid'
  end

  #init!
  describe '#init' do
    let(:expected_dictionary_metadata) do
      {
        0 => {},
        1 => { metadata_key0: :metadata_object0 }
      }
    end

    context 'when the dictionary_id is valid' do
      before do
        allow(subject).to receive(:dictionary_id!).and_return(0)
      end

      it 'initializes the metadata associated with the dictionary id for the given metadata_key' do
        expect(subject.get_dictionary_metadata(metadata_key: metadata_key)).to eq dictionary_metadata.dig(0, metadata_key)
        subject.init(metadata_key: metadata_key)
        expect(subject.get_dictionary_metadata(metadata_key: metadata_key)).to be_nil
        expect(dictionary_metadata).to eq expected_dictionary_metadata
      end

      it_behaves_like 'the dictionary_metadata object reference has not changed' do
        let(:expected_dictionary_metadata) { dictionary_metadata }
        let(:actual_dictionary_metadata) { subject.dictionary_metadata }
      end

      it_behaves_like 'the dictionary_cache object reference has not changed' do
        let(:expected_dictionary_cache) { dictionary_cache }
        let(:actual_dictionary_cache) { subject.dictionary_cache_service.dictionary_cache }
      end
    end

    context 'when the dictionary_id is INVALID' do
      it 'raises an error' do
        expect { subject.init(metadata_key: metadata_key) }.to raise_error "A dictionary id could not be found for key '#{key}'."
      end
    end
  end

  #dictionary_metadata?
  describe '#dictionary_metadata?' do
  end

  #get_dictionary_metadata
  describe '#get_dictionary_metadata' do
  end

  #set_dictionary_metadata
  describe '#set_dictionary_metadata' do
  end
end
