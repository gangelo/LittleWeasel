# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::DictionaryManager do
  subject { described_class.instance.reset! }

  before do
    LittleWeasel.configure { |_config| }
    subject
  end

  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:file) { dictionary_path_for(file_name: dictionary_key.key) }

  shared_examples 'when an invalid dictionary key was passed' do
    it 'raises an error' do
      expect { subject.add(dictionary_key: :bad_key, file: file) }.to raise_error(/does not respond_to\? :key/)
    end
  end

  #.instance
  describe '.instance' do
    it 'does not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  #add_dictionary_reference
  describe '#add_dictionary_reference' do
    describe 'when a valid key is passed' do
      describe 'when the dictionary is added' do
        it 'adds the dictionary to the cache' do
          expect { subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file) }.to \
            change { subject.count }.from(0).to(1)
        end

        it 'returns the dictionary manager instance' do
          expect(subject.add_dictionary_reference(dictionary_key: dictionary_key, file: file)).to eq subject
        end
      end
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

  #unload
  xdescribe '#unload_dictionary' do
    before do
      subject.reset
      subject.add(dictionary_key: dictionary_key, file: file)
    end

    it_behaves_like 'when an invalid dictionary key was passed'

    it 'unloads the dictionary from the cache but keeps the metadata' do
      subject.unload(dictionary_key: dictionary_key)
      expect(subject.exist?(key: dictionary_key.key)).to eq true
      expect(subject.metadata?(key: dictionary_key.key)).to eq true
      expect(subject.loaded?(key: dictionary_key.key)).to eq false
    end

    it 'returns true' do
      expect(subject.unload(dictionary_key: dictionary_key)).to eq true
    end
  end

  #kill
  xdescribe '#kill_dictionary' do
    it_behaves_like 'when an invalid dictionary key was passed'

    it 'kills the dictionary'
  end

  #reset!
  xdescribe '#reset!' do
    it_behaves_like 'when an invalid dictionary key was passed'

    it 'resets the cache'
  end
end
