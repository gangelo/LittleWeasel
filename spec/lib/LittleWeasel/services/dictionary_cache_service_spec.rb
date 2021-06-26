# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryCacheService do
  include_context 'dictionary cache'
  include_context 'dictionary keys'

  subject { create(:dictionary_cache_service, dictionary_cache: dictionary_cache) }

  let(:en_us_dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:en_gb_dictionary_key) { dictionary_key_for(language: :en, region: :gb) }
  let(:es_es_dictionary_key) { dictionary_key_for(language: :es, region: :es) }

  let(:dictionary_key) { en_us_dictionary_key }
  let(:key) { dictionary_key.key }
  let(:file) { "#{ dictionary_path_for(file_name: key) }" }
  let(:file_minus_ext) { key }
  let(:dictionary_cache) { {} }
  let!(:initialized_dictionary_cache) { LittleWeasel::Modules::DictionaryCacheKeys.initialize_dictionary_cache(dictionary_cache: {}) }

  shared_examples 'the dictionary_cache object reference has not changed' do
    it 'the dictionary_cache object has not changed' do
      expect(actual_dictionary_cache).to eq expected_dictionary_cache
    end
  end

  describe 'class methods' do
    #.init
    describe '.init' do
      subject! { create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache) }

      before do
        create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache, dictionary_key: en_gb_dictionary_key)
      end

      it 'resets the cache to an initiaized state for all keys in the cache' do
        expect { described_class.init(dictionary_cache: dictionary_cache) }.to change { dictionary_cache }.to(initialized_dictionary_cache)
      end

      describe 'maintains dictionary_cache object integrity' do
        it_behaves_like 'the dictionary_cache object reference has not changed' do
          before { subject }
          let(:actual_dictionary_cache) { described_class.init(dictionary_cache: dictionary_cache) }
          let(:expected_dictionary_cache) { dictionary_cache }
        end
      end
    end

    #.init?
    describe '.init?' do
      context 'when passing an initialized dictionary cache Hash' do
        it 'returns true' do
          expect(described_class.init? dictionary_cache: initialized_dictionary_cache).to eq true
        end
      end

      context 'when passing a NON-initialized dictionary cache Hash' do
        before do
          subject.add_dictionary_file_source file: file
        end

        it 'returns false' do
          expect(described_class.init? dictionary_cache: dictionary_cache).to eq false
        end
      end
    end

    #.count
    describe '.count' do
      context 'when there are no dictionary references' do
        subject { create(:dictionary_cache_service) }

        it 'returns 0' do
          expect(described_class.count(dictionary_cache: subject.dictionary_cache)).to eq 0
        end
      end

      context 'when there are are dictionary references' do
        subject { create(:dictionary_cache_service, dictionary_reference: true) }

        it 'returns the dictionary reference count' do
          expect(described_class.count(dictionary_cache: subject.dictionary_cache)).to eq 1
        end
      end
    end

    #.populated?
    describe '.populated?' do
      context 'when there are no dictionary references' do
        subject { create(:dictionary_cache_service) }

        it 'returns false' do
          expect(described_class.populated?(dictionary_cache: subject.dictionary_cache)).to eq false
        end
      end

      context 'when there are are dictionary references' do
        subject { create(:dictionary_cache_service, dictionary_reference: true) }

        it 'returns true' do
          expect(described_class.populated?(dictionary_cache: subject.dictionary_cache)).to eq true
        end
      end
    end
  end

  #init
  describe '#init' do
    subject! { create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache) }

    let!(:subject2) { create(:dictionary_cache_service, dictionary_reference: true, dictionary_cache: dictionary_cache, dictionary_key: en_gb_dictionary_key) }
    let!(:original_dictionary_cache) { dictionary_cache }

    it 'resets the cache to an initiaized state for the GIVEN KEY ONLY' do
      expect { subject.init }.to change { dictionary_cache }.from(original_dictionary_cache).to(subject2.dictionary_cache)
      expect { subject2.init }.to change { dictionary_cache }.from(original_dictionary_cache).to(subject.dictionary_cache)
    end

    describe 'maintains dictionary_cache object integrity' do
      it_behaves_like 'the dictionary_cache object reference has not changed' do
        let(:actual_dictionary_cache) { subject.init.dictionary_cache }
        let(:expected_dictionary_cache) { dictionary_cache }
      end
    end
  end

  #dictionary_reference?
  describe '#dictionary_reference?' do
    subject { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_reference: true, dictionary_cache: dictionary_cache) }

    context 'when the dictionary reference exists' do
      it 'returns true' do
        expect(subject.dictionary_reference?).to eq true
      end
    end

    context 'when the dictionary reference DOES NOT exist' do
      subject! { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

      let(:dictionary_key) { es_es_dictionary_key }
      let(:dictionary_cache) do
        dictionary_keys = [
          { dictionary_key: en_us_dictionary_key },
          { dictionary_key: en_gb_dictionary_key },
        ]
        dictionary_cache_from dictionary_keys: dictionary_keys
      end

      it 'returns false' do
        expect(subject.dictionary_reference?).to eq false
      end
    end

    describe 'maintains dictionary_cache object integrity' do
      it_behaves_like 'the dictionary_cache object reference has not changed' do
        let(:actual_dictionary_cache) { subject.dictionary_cache }
        let(:expected_dictionary_cache) { dictionary_cache }
      end
    end
  end

  #add_dictionary_memory_source
  describe '#add_dictionary_memory_source' do
    it 'does something'
  end

  #add_dictionary_file_source
  describe '#add_dictionary_file_source' do
    subject! { create(:dictionary_cache_service, dictionary_key: dictionary_key).add_dictionary_file_source(file: file) }

    context 'when a dictionary file source for the key already exists' do
      it 'raises an error' do
        expect do
          create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: subject.dictionary_cache).add_dictionary_file_source(file: file)
        end.to raise_error "Dictionary reference for key '#{key}' already exists."
      end
    end

    context 'when a dictionary file source for the key DOES NOT already exist' do
      describe 'when the dictionary source dictionary file key already exists' do
        let!(:original_dictionary_cache) { subject.dictionary_cache }
        let(:expected_dictionary_cache) do
          dictionary_keys = [
            { dictionary_key: dictionary_key, dictionary_reference: dictionary_key.key },
            # Note: we're pointing to the existing dictionary file referenced by en-US.
            { dictionary_key: en_gb_dictionary_key, dictionary_reference: dictionary_key.key }
          ]
          dictionary_cache_from(dictionary_keys: dictionary_keys)
        end

        it 'a dictionary file source is created whose dictionary file key points to the existing dictionary file' do
          expect do
            create(:dictionary_cache_service, dictionary_key: en_gb_dictionary_key, dictionary_cache: subject.dictionary_cache).add_dictionary_file_source(file: file)
          end.to change { subject.dictionary_cache }.from(original_dictionary_cache).to(expected_dictionary_cache)
        end
      end

      describe 'when the dictionary file source dictionary file key DOES NOT already exist' do
        it 'creates the dictionary reference' do
          en_gb_file = dictionary_path_for(file_name: en_gb_dictionary_key.key)
          expect(create(:dictionary_cache_service, dictionary_key: en_gb_dictionary_key, dictionary_cache: subject.dictionary_cache).add_dictionary_file_source(file: en_gb_file).dictionary_reference?).to eq true
        end
      end
    end

    describe 'maintains dictionary_cache object integrity' do
      it_behaves_like 'the dictionary_cache object reference has not changed' do
        subject { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }
        let(:actual_dictionary_cache) { subject.add_dictionary_file_source(file: file).dictionary_cache }
        let(:expected_dictionary_cache) { dictionary_cache }
      end
    end
  end

  #dictionary_file
  describe '#dictionary_file' do
    context 'when a file source is used' do
      subject! { create(:dictionary_cache_service, dictionary_key: dictionary_key).add_dictionary_file_source(file: file) }

      it 'returns the dictionary file' do
        expect(subject.dictionary_file).to eq file
      end
    end

    context 'when a memory source is used' do
      subject! { create(:dictionary_cache_service, dictionary_key: dictionary_key).add_dictionary_memory_source }

      let(:dictionary_words) { dictionary_words_for(dictionary_file_path: file) }

      it 'returns the dictionary file' do
        expect(subject.dictionary_file).to eq LittleWeasel::Modules::DictionarySourceable::MEMORY_SOURCE
      end
    end
  end

  #dictionary_id!
  describe '#dictionary_id!' do
    context 'when a dictionary id associated with the dictionary key exists' do
      subject! { create(:dictionary_cache_service, dictionary_cache: dictionary_cache, dictionary_key: dictionary_key, dictionary_reference: true) }

      let(:subject2) do
        create(:dictionary_cache_service, dictionary_cache: dictionary_cache, dictionary_key: en_gb_dictionary_key, dictionary_reference: true)
      end

      it 'returns the dictionary id' do
        expect(subject.dictionary_id!).to eq 0
        expect(subject2.dictionary_id!).to eq 1
      end
    end

    context 'when a dictionary id associated with the dictionary key DOES NOT exist' do
      subject { create(:dictionary_cache_service) }

      it 'raises an error' do
        expect { subject.dictionary_id! }.to raise_error "A dictionary id could not be found for key '#{key}'."
      end
    end
  end

  #dictionary_loaded?
  describe '#dictionary_loaded?' do
    context 'when the dictionary reference does not exist' do
      subject { create(:dictionary_cache_service, dictionary_cache: dictionary_cache) }

      it 'returns false' do
        expect(subject.dictionary_loaded?).to eq false
      end
    end

    context 'when the dictionary is already loaded' do
      subject { create(:dictionary_cache_service, dictionary_cache: dictionary_cache, dictionary_reference: true, load: true) }

      it 'returns true' do
        expect(subject.dictionary_loaded?).to eq true
      end
    end

    context 'when the dictionary is NOT already loaded' do
      subject { create(:dictionary_cache_service, dictionary_cache: dictionary_cache, dictionary_reference: true) }

      it 'returns false' do
        expect(subject.dictionary_loaded?).to eq false
      end
    end
  end

  #dictionary_object
  describe '#dictionary_object' do
    context 'when the dictionary object is already cached/loaded' do
      subject { create(:dictionary_cache_service, dictionary_reference: true, load: true) }

      it 'returns the dictionary object' do
        expect(subject.dictionary_object).to be_kind_of LittleWeasel::Dictionary
      end
    end

    context 'when the dictionary object is NOT already cached/loaded' do
      context 'when the dictionary reference exists' do
        it 'returns an object that is not present?' do
          expect(create(:dictionary_cache_service, dictionary_reference: true).dictionary_object).to_not be_present
        end
      end

      context 'when the dictionary reference DOES NOT exist' do
        it 'returns an object that is not present?' do
          expect(create(:dictionary_cache_service).dictionary_object).to_not be_present
        end
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
        expect(subject.dictionary_object!).to be_kind_of LittleWeasel::Dictionary
      end
    end
  end

  #dictionary_object=
  describe '#dictionary_object=' do
    context 'when the dictionary object passed is invalid' do
      subject { create(:dictionary_cache_service) }

      context 'when nil' do
        it 'raises an error' do
          expect { subject.dictionary_object = nil }.to raise_error 'Argument object is not a Dictionary object'
        end
      end

      context 'when not a Dictionary object' do
        it 'raises an error' do
          expect { subject.dictionary_object = :wrong_object }.to raise_error 'Argument object is not a Dictionary object'
        end
      end
    end

    context 'when there is NO dictionary reference' do
      before do
        allow(dictionary_object).to receive(:is_a?).and_return(true)
      end

      subject { create(:dictionary_cache_service, dictionary_cache: dictionary_cache, dictionary_key: dictionary_key, dictionary_reference: false) }

      let(:dictionary_object) { Object.new }

      it 'raises an error' do
        expect { subject.dictionary_object = dictionary_object }.to raise_error "The dictionary reference associated with key '#{key}' could not be found."
      end
    end

    context 'when the dictionary is already loaded/cached and different from the dictionary object passed' do
      subject { create(:dictionary_cache_service, dictionary_cache: dictionary_cache, dictionary_key: dictionary_key, dictionary_reference: true, load: true) }

      let(:dictionary) { create(:dictionary, dictionary_cache: dictionary_cache, dictionary_key: dictionary_key) }

      it 'raises an error' do
        expect { subject.dictionary_object = dictionary }.to raise_error  "The dictionary is already loaded/cached for key '#{key}'; use #unload or #kill first."
      end
    end

    context 'when the dictionary is already loaded/cached and the dictionary object is the same as the one that is loaded/cached' do
      subject { create(:dictionary_cache_service, dictionary_reference: true, load: true) }

      it 'returns the same object' do
        expect(subject.dictionary_object = subject.dictionary_object).to eq subject.dictionary_object
      end
    end

    context 'when the dictionary is NOT already loaded/cached' do
      subject { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: true) }

      let(:dictionary) { create(:dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

      it 'updates the dictionary object' do
        expect { subject.dictionary_object = dictionary }.to_not raise_error
        expect(subject.dictionary_object).to eq dictionary
      end
    end
  end

  #unload_dictionary
  describe '#unload_dictionary' do
    #let!(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

    context 'when the dictionary has no reference in the dictionary cache' do
      it 'raises an error' do
        expect{ subject.unload_dictionary }.to raise_error  "The dictionary reference associated with key '#{key}' could not be found."
      end
    end

    context 'when the dictionary is NOT loaded/cached' do
      before do
        subject.add_dictionary_file_source file: file
      end

      it 'raises an error' do
        expect{ subject.unload_dictionary }.to raise_error "The dictionary associated with key '#{key}' is not loaded/cached."
      end
    end

    context 'when the dictionary is loaded/cached' do
      subject { create(:dictionary_cache_service, dictionary_cache: dictionary_cache, dictionary_reference: file_minus_ext, load: true) }

      let!(:unloaded_dictionary_object) { subject.dictionary_object! }

      it 'unloads the dictionary from the dictionary cache and returns the unloaded dictionary object' do
        expect(subject.dictionary_loaded?).to be true
        expect(subject.unload_dictionary).to be unloaded_dictionary_object
        expect(subject.dictionary_loaded?).to be false
      end
    end
  end
end
