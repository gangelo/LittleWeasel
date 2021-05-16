# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryCacheService do
  include_context 'dictionary cache keys'

  subject do
    create(:dictionary_cache_service, dictionary_cache: dictionary_cache)
  end

  before { LittleWeasel.configure { |_config| } }

  let(:dictionary_key) { LittleWeasel::Dictionaries::DictionaryKey.new(language: :en, region: :us) }
  let(:key) {  dictionary_key.key }
  let(:file) { "#{key}.txt" }
  let(:dictionary_file_key) { file }
  let(:dictionary_cache) { {} }
  let(:initialized_dictionary_cache) { described_class.reset!({}) }

  def dictionary_cache_merge!(hash)
    dictionary_cache[DICTIONARY_CACHE][dictionary_file_key].merge!(hash)
  end

  def dictionary_cache_add_dictionary_reference(key, dictionary_file_key)
    dictionary_cache[DICTIONARY_REFERENCES][key] = dictionary_file_key
    dictionary_cache
  end

  shared_examples 'the dictionary_cache object reference has not changed' do
    it 'the dictionary_cache object has not changed' do
      expect(subject).to eq dictionary_cache
     end
  end

  describe 'class methods' do
    #.reset!
    describe '.reset!' do
      subject { create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache) }

      before do
        dictionary_key = create(:dictionary_key, language: :en, region: :gb)
        create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache, dictionary_key: dictionary_key)
      end

      it 'resets the cache to an initiaized state for all keys in the cache' do
        expect { described_class.reset!(dictionary_cache) }.to change { dictionary_cache }.to(initialized_dictionary_cache)
      end

      describe 'maintains dictionary_cache object integrity' do
        it_behaves_like 'the dictionary_cache object reference has not changed' do
          subject { described_class.reset! dictionary_cache }
        end
      end
    end

    #.count
    describe '.count' do
      context 'when there are no dictionary references' do
        subject { create(:dictionary_cache_service) }

        it 'returns 0' do
          expect(described_class.count(subject.dictionary_cache)).to eq 0
        end
      end

      context 'when there are are dictionary references' do
        subject { create(:dictionary_cache_service, dictionary_reference: true) }

        it 'returns the dictionary reference count' do
          expect(described_class.count(subject.dictionary_cache)).to eq 1
        end
      end
    end

    #.populated?
    describe '.populated?' do
      context 'when there are no dictionary references' do
        subject { create(:dictionary_cache_service) }

        it 'returns false' do
          expect(described_class.populated?(subject.dictionary_cache)).to eq false
        end
      end

      context 'when there are are dictionary references' do
        subject { create(:dictionary_cache_service, dictionary_reference: true) }

        it 'returns true' do
          expect(described_class.populated?(subject.dictionary_cache)).to eq true
        end
      end
    end
  end

  #reset!
  describe '#reset!' do
    subject { create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache) }

    before do
      subject
      dictionary_key = create(:dictionary_key, language: :en, region: :gb)
      create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache, dictionary_key: dictionary_key)
      original_dictionary_cache
    end

    let(:original_dictionary_cache) { dictionary_cache }
    let(:expected_dictionary_cache) do
      {
        'dictionary_references'=>
        {
          'en-GB'=>
          {
            'dictionary_file_key'=> 'en-GB.txt'
          }
        },
        'dictionary_cache'=>
        {
          'en-GB.txt'=>
          {
            'dictionary_metadata'=> {},
            'dictionary_object'=> {}
          }
        }
      }
    end

    it 'resets the cache to an initiaized state for the GIVEN KEY ONLY' do
      expect do
        binding.pry
        subject.reset!
        binding.pry
      end.to change { dictionary_cache }.from(original_dictionary_cache).to(expected_dictionary_cache)
    end

    describe 'maintains dictionary_cache object integrity' do
      it_behaves_like 'the dictionary_cache object reference has not changed' do
        subject { described_class.reset! dictionary_cache }
      end
    end
  end

  #count
  xdescribe '#count' do
    context 'when there are no dictionary references in the dictionary cache' do
      it 'returns 0' do
        expect(subject.count).to eq 0
      end
    end

    context 'when there are dictionary references in the dictionary cache' do
      before do
        subject.add(key: key, file: file)
        subject.add(key: 'en-GB', file: 'en-GB.txt')
      end

      it 'returns the expected count' do
        expect(subject.count).to eq 2
      end
    end
  end

  #init!
  xdescribe '#init!' do
    it 'responds_to? #init! as an alias for #reset!' do
      expect(subject).to respond_to(:init!)
    end

    describe 'maintains dictionary_cache object integrity' do
      it_behaves_like 'the dictionary_cache object reference has not changed' do
        let(:func) { :init! }
        let(:args) { {} }
      end
    end
  end

  #exist?
  describe '#exist?' do
    context 'when the dictionary reference exists' do
      before do
        subject.add(key: key, file: file)
      end

      it 'returns true' do
        expect(subject.exist?(key: key)).to eq true
      end
    end

    context 'when the dictionary reference DOES NOT exist' do
      it 'returns false' do
        expect(subject.exist?(key: key)).to eq false
      end
    end

    describe 'maintains dictionary_cache object integrity' do
      it_behaves_like 'the dictionary_cache object reference has not changed' do
        let(:func) { :exist? }
        let(:args) { { key: key } }
      end
    end
  end

  #add
  describe '#add' do
    context 'when a dictionary reference for the key already exists' do
      before do
        subject
        dictionary_cache_add_dictionary_reference(key, dictionary_file_key)
      end

      it 'raises an error' do
        expect { subject.add(key: key, file: file) }.to raise_error "Dictionary reference for key '#{key}' already exists; use #load instead."
      end
    end

    context 'when a dictionary reference for the key DOES NOT already exist' do
      it 'a dictionary reference is created' do
        expect { subject.add(key: key, file: file) }.to change { subject.exist?(key: key) }.from(false).to(true)
      end

      it 'does not raise an error' do
        expect { subject.add(key: key, file: file) }.to_not raise_error
      end

      describe 'when dictionary cache DOES NOT already exist for the dictionary' do
        it 'a dictionary cache for the dictionary is created' do
          expect { subject.add(key: key, file: file) }.to change { dictionary_cache }
        end
      end
    end

    describe 'maintains dictionary_cache object integrity' do
      it_behaves_like 'the dictionary_cache object reference has not changed' do
        let(:func) { :add }
        let(:args) { { key: key, file: file } }
      end
    end
  end

  #loaded?
  describe '#loaded?' do
    context 'when the dictionary is already loaded' do
      before do
        subject.add(key: key, file: file)
        dictionary_cache[described_class::DICTIONARY_CACHE][dictionary_file_key][described_class::DICTIONARY_OBJECT] = { loaded: true }
      end

      it 'returns true' do
        expect(subject.loaded?(key: key)).to eq true
      end
    end

    context 'when the dictionary is NOT already loaded' do
      it 'raises an error' do
        expect { subject.loaded?(key: key) }.to raise_error "Argument key '#{key}' does not exist; use #add to add it first."
      end
    end

    describe 'maintains dictionary_cache object integrity' do
      before do
        subject.add(key: key, file: file)
      end

      it_behaves_like 'the dictionary_cache object reference has not changed' do
        let(:func) { :loaded? }
        let(:args) { { key: key } }
      end
    end
  end

  #dictionary_object!
  describe '#dictionary_object!' do
    describe 'when the dictionary is NOT in the loaded/cached' do
      it 'raises an error' do
        expect { subject.dictionary_object! }.to raise_error("The dictionary associated with argument key '#{key}' is not in the cache; load it from disk first.")
      end
    end

    describe 'when the dictionary is loaded/cached' do
      subject { create(:dictionary_cache_service, dictionary_reference: true, load: true) }

      it 'returns the dictionary cache for the dictionary' do
        expect(subject.dictionary_reference?).to eq true
        expect(subject.dictionary_loaded?).to eq true
        expect(subject.dictionary_object).to be_kind_of LittleWeasel::Dictionary
      end
    end
  end

  #dictionary_object=
  describe '#dictionary_object=' do
    context 'when the dictionary object passed is invalid' do
      context 'when nil' do
        it 'raises an error'
      end

      context 'when not a Dictionary object' do
        it 'raises an error'
      end
    end

    context 'when the dictionary reference does not exist' do
      it 'raises an error'
    end

    context 'when the dictionary is already loaded/cached and different from the dictionary object passed' do
      it 'raises an error'
    end

    context 'when the dictionary is already loaded/cached and the dictionary object is the same as the one that is loaded/cached' do
      it 'returns the same object'
    end

    context 'when the dictionary is NOT already loaded/cached and the dictionary object is DIFFERENT from the one that is loaded/cached' do
      it 'updates the dictionary object'
    end
  end
end
