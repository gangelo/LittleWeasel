# frozen_string_literal: true

require 'spec_helper'
require 'observer'

RSpec.describe LittleWeasel::Metadata::InvalidWords::InvalidWordsMetadata do
  subject do
    dictionary_manager.reset!
    dictionary_manager.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
    dictionary.dictionary_metadata.observers[:invalid_words_metadata][:metadata_observer]
  end

  let(:dictionary) { dictionary_manager.load_dictionary(dictionary_key: dictionary_key) }
  let(:dictionary_manager) { LittleWeasel::DictionaryManager.instance }

  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:dictionary_cache) { {} }
  let(:file) { dictionary_path_for file_name: dictionary_key.key }

  let(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }
  let(:invalid_words_metadata) { described_class.new(dictionary_metadata: dictionary_metadata, dictionary_words: dictionary_words, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }
  let(:dictionary_metadata) do
    Class.new do
      include Observable
    end.new
  end

  let(:configuration) { LittleWeasel.configuration }

  #new
  describe '#new' do
    context 'with invalid arguments' do
      subject { invalid_words_metadata }

      before do
        dictionary_cache_service.add_dictionary_reference(file: file)
      end

      context 'with invalid dictionary metadata' do
        let(:dictionary_words) { { 'a' => true, 'b' => true } }
        let(:dictionary_metadata) { :wrong_type }

        it 'raises an error' do
          expect { subject }.to raise_error "Argument dictionary_metadata is not an Observable: #{dictionary_metadata.class}."
        end
      end

      context 'with an invalid dictionary' do
        let(:dictionary_words) { :wrong_type }

        it 'raises an error' do
          expect { subject }.to raise_error "Argument dictionary_words is not a Hash: #{dictionary_words.class}."
        end
      end
    end

    context 'with a valid arguments' do
      before do
        subject.word_search params: { word: 'badword1', word_found: false, word_valid: false }
        subject.word_search params: { word: 'badword2', word_found: false, word_valid: false }
      end

      it 'instantiates without error' do
        expect { subject }.to_not raise_error
      end

      it 'initializes the necessary object attributes' do
        expect(subject.on?).to eq true
        expect(subject.off?).to eq false
        expect(subject.value).to eq configuration.max_invalid_words_bytesize
        expect(subject.value_exceeded?).to eq false
        expect(subject.current_invalid_word_bytesize).to eq 16
        expect(subject.cache_invalid_words?).to eq true
      end
    end

    context 'with an invalid dictionary words Hash' do
      subject { invalid_words_metadata }

      context 'when nil' do
        let(:dictionary_words) {}

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context 'when not a Hash' do
        let(:dictionary_words) { :not_an_array }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end

  #refresh!
  describe '#refresh!' do
    it 'the metadata is refreshed' do
      expect do
        subject.dictionary_metadata.dictionary_words['not-found'] = false
        subject.refresh!
      end.to change { subject.current_invalid_word_bytesize }
      .from(0).to(9)
    end
  end

  #Update
  describe '#update' do
    context 'with an action NOT on the whitelist' do
      let(:action) { :bad_action! }
      let(:params) { :params }

      it 'raises an error' do
        expect { subject.update(action, params) }.to raise_error "Argument action is not in the actions_whitelist: #{action}"
      end
    end

    context 'with an action on the whitelist' do
      it 'carries out the requested action' do
        expect do
          dictionary.word_valid? 'not-found'
        end.to change { subject.current_invalid_word_bytesize }
        .from(0).to(9)
      end
    end
  end
end
