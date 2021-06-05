# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::DictionaryFileLoader, type: :module do
  subject do
    dictionary_cache_service.reset! dictionary_cache: dictionary_cache
    dictionary_file_loader
  end

  let(:dictionary_file_loader) do
    Class.new do
      include LittleWeasel::Modules::DictionaryFileLoader

      attr_reader :dictionary_key, :dictionary_cache, :config

      def initialize(dictionary_key, dictionary_cache)
        self.dictionary_key = dictionary_key
        self.dictionary_cache = dictionary_cache
        self.config = LittleWeasel.configuration
      end

      private

      attr_writer :dictionary_key, :dictionary_cache, :config
    end.new(dictionary_key, dictionary_cache)
  end

  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}

  let(:dictionary_cache_service) { LittleWeasel::Services::DictionaryCacheService }
  let(:dictionary_key) { LittleWeasel::DictionaryKey.new(language: language, region: region, tag: tag) }
  let(:key) {  dictionary_key.key }
  let(:file) { dictionary_path_for locale: dictionary_key.locale }
  let(:dictionary_file_key) { file }
  let(:dictionary_cache) { {} }

  #load
  describe '#load' do
    context 'with an invalid dictionary file' do
      context 'when it cannot be found' do
        let(:dictionary_path) { region_dictionary_path language: :bad, region: :worse }

        it 'raises an error' do
          expect { subject.load dictionary_path }.to raise_error LittleWeasel::Errors::DictionaryFileNotFoundError
        end
      end

      context 'when it is empty' do
        let(:dictionary_path) { dictionary_path_for file_name: 'empty-dictionary' }

        it 'raises an error' do
          expect { subject.load dictionary_path  }.to raise_error LittleWeasel::Errors::DictionaryFileEmptyError
        end
      end

      context 'when it is too large' do
        before do
          allow(LittleWeasel.configuration).to receive(:max_dictionary_file_bytes).and_return 1
        end

        let(:dictionary_path) { language_dictionary_path language: :en }

        it 'raises an error' do
          expect { subject.load dictionary_path  }.to raise_error LittleWeasel::Errors::DictionaryFileTooLargeError
        end
      end
    end

    context 'with a valid dictionary file' do
      subject { dictionary_file_loader.load dictionary_path }

      let(:dictionary_path) { region_dictionary_path language: language, region: region }

      context 'when the dictionary file is already loaded/cached' do
        before { subject }

        it 'does not raise an error' do
          expect { subject }.to_not raise_error
        end
      end

      context 'when the dictionary is NOT already loaded/cached' do
        let(:expected_dictionary_key_key) { LittleWeasel::DictionaryKey.new(language: language, region: region, tag: tag).key }
        let(:expected_results) do
          ['apple',
           'better',
           'cat',
           'dog',
           'everyone',
           'fat',
           'game',
           'help',
           'italic',
           'jasmine',
           'kelp',
           'love',
           'man',
           'nope',
           'octopus',
           'popeye',
           'queue',
           'ruby',
           'stop',
           'top',
           'ultimate',
           'very',
           'was',
           'xylophone',
           'yes',
           'zebra']
        end

        it 'returns an Array of dictionary words loaded from the file' do
          # This test won't pass if we're not testing against an assumed
          # dictionary file.
          expect(dictionary_key.key).to eq expected_dictionary_key_key
          expect(subject).to eq expected_results
        end
      end
    end
  end
end
