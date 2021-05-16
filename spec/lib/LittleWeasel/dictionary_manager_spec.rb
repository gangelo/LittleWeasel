# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::DictionaryManager do
  subject { create(sym_for(described_class)) }

  let(:dictionary_key) { LittleWeasel::Dictionaries::DictionaryKey.new(language: :en, region: :us, tag: tag) }
  let(:file) { dictionary_path_for(locale: dictionary_key.locale) }
  let(:tag) {}

  shared_examples 'when an invalid dictionary key was passed' do
    it 'raises an error' do
      expect { subject.instance.add(dictionary_key: :bad_key, file: file) }.to raise_error(/does not respond_to\? :key/)
    end
  end

  #.instance
  describe '.instance' do
    it 'does not raise an error' do
      expect { subject.instance }.not_to raise_error
    end
  end

  #add
  describe '#add' do
    describe 'when a valid key is passed' do
      before(:each) do
        subject.instance.reset
      end

      describe 'when the dictionary is added' do
        it 'adds the dictionary to the cache' do
          expect { subject.instance.add(dictionary_key: dictionary_key, file: file) }.to \
            change { subject.instance.count }.from(0).to(1)
        end

        it 'returns the dictionary manager instance' do
          expect(subject.instance.add(dictionary_key: dictionary_key, file: file)).to eq subject.instance
        end
      end
    end

    it_behaves_like 'when an invalid dictionary key was passed'
  end

  #load
  describe '#load' do
    before do
      subject.instance.reset
      subject.instance.add(dictionary_key: dictionary_key, file: file)
    end

    let(:dictionary_key) { LittleWeasel::Dictionaries::DictionaryKey.new(language: :en, region: :us, tag: tag) }
    let(:tag) { :tagged }

    it_behaves_like 'when an invalid dictionary key was passed'

    it 'loads and returns a dictionary object' do
      expect(subject.instance.load(dictionary_key: dictionary_key)).to be_kind_of LittleWeasel::Dictionaries::Dictionary
    end
  end

  #unload
  describe '#unload' do
    before do
      subject.instance.reset
      subject.instance.add(dictionary_key: dictionary_key, file: file)
    end

    it_behaves_like 'when an invalid dictionary key was passed'

    it 'unloads the dictionary from the cache but keeps the metadata' do
      subject.instance.unload(dictionary_key: dictionary_key)
      expect(subject.instance.exist?(key: dictionary_key.key)).to eq true
      expect(subject.instance.metadata?(key: dictionary_key.key)).to eq true
      expect(subject.instance.loaded?(key: dictionary_key.key)).to eq false
    end

    it 'returns true' do
      expect(subject.instance.unload(dictionary_key: dictionary_key)).to eq true
    end
  end

  #kill
  describe '#kill' do
    it_behaves_like 'when an invalid dictionary key was passed'

    it 'kills the dictionary'
  end

  #reset
  describe '#reset' do
    it_behaves_like 'when an invalid dictionary key was passed'

    it 'resets the cache'
  end
end
