# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::DictionaryLoader, type: :module do
  subject { dictionary_loader }

  before do
    configuration
  end

  let(:configuration) { LittleWeasel.configure { |_| } }
  let(:dictionaries_hash) { {} }
  let(:dictionary_loader) do
    Class.new do
      include LittleWeasel::Modules::DictionaryLoader

      attr_reader :dictionaries_hash

      def initialize(dictionaries_hash)
        self.dictionaries_hash = dictionaries_hash
      end

      private

      attr_writer :dictionaries_hash
    end.new(dictionaries_hash)
  end
  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:hash_key) { hash_key_for language, region, tag }
  let (:invalid_dictionary_path) { build_dictionary_path_for file_name: 'invalid' }

  #load_using_file
  describe '#load_using_file' do
    context 'with an invalid dictionary file' do
      subject { dictionary_loader.load_using_file dictionary_path }

      let (:dictionary_path) { invalid_dictionary_path }

      it_behaves_like 'an invalid dictionary file'
    end

    context 'with a valid dictionary file' do
      subject { dictionary_loader.load_using_file dictionary_path }

      let (:dictionary_path) { region_dictionary_path language: language, region: region }
      let(:loaded_dictionary) { dictionaries_hash[hash_key] }

      context 'when it is already loaded' do
        before { subject }

        it 'does not raise an error' do
          expect { subject }.to_not raise_error
        end

        it_behaves_like 'a temprarily loaded dictionary'
      end

      context 'when it is not already loaded' do
        it_behaves_like 'a valid dictionary file'
        it_behaves_like 'a temprarily loaded dictionary'
      end
    end
  end

  #load_using_file!
  describe '#load_using_file!' do
    context 'with an invalid dictionary file' do
      subject { dictionary_loader.load_using_file! dictionary_path }

      let (:dictionary_path) { invalid_dictionary_path }

      it_behaves_like 'an invalid dictionary file'
    end

    context 'with a valid dictionary file' do
      subject { dictionary_loader.load_using_file! dictionary_path }

      let (:dictionary_path) { region_dictionary_path language: language, region: region }
      let(:loaded_dictionary) { dictionaries_hash[hash_key] }

      context 'when it is already loaded' do
        before { subject }

        it 'does not raise an error' do
          expect { subject }.to_not raise_error
        end

        it_behaves_like 'a temprarily loaded dictionary'
      end

      context 'when it is not already loaded' do
        it_behaves_like 'a valid dictionary file'
        it_behaves_like 'a temprarily loaded dictionary'
      end
    end
  end
end
