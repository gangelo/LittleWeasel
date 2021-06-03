# frozen_string_literal: true

require 'spec_helper'
require 'observer'

RSpec.describe LittleWeasel::Metadata::InvalidWords::InvalidWordsMetadata do
  subject do
    dictionary_manager.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
    dictionary.dictionary_metadata.observers[:invalid_words_metadata][:metadata_object]
  end

  before(:each) do
    subject.refresh!
  end

  let(:dictionary) { dictionary_manager.load_dictionary(dictionary_key: dictionary_key) }
  let(:dictionary_manager) { LittleWeasel::DictionaryManager.instance }

=begin
  subject do
    create(:max_invalid_words_bytesize_metadata,
      dictionary_metadata: dictionary_metadata,
      dictionary: dictionary,
      dictionary_key: dictionary_key,
      dictionary_cache: dictionary_cache)
  end

  let(:dictionary_cache_service) do
    create(:dictionary_cache_service,
      dictionary_key: dictionary_key,
      dictionary_cache: dictionary_cache)
      # DO NOT add a referene by default.
      # dictionary_reference: dictionary_key.key)
  end

  let(:dictionary_metadata) do
    create(:dictionary_metadata,
      dictionary: create(:dictionary_hash, dictionary_words: dictionary_words),
      dictionary_key: dictionary_key,
      dictionary_cache: dictionary_cache)
  end
  let(:dictionary) do
    create(:dictionary,
      dictionary_key: dictionary_key,
      dictionary_cache: dictionary_cache,
      dictionary_words: dictionary_words)
  end
=end
  let(:dictionary_key) { create(:dictionary_key, language: language, region: region, tag: tag) }
  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  # let(:dictionary_words) { dictionary_words_for dictionary_file_path: file }
  let(:dictionary_cache) { {} }
  let(:file) { dictionary_path_for file_name: dictionary_key.key }

  let!(:configuration) do
    LittleWeasel.configure { |_config| }
    LittleWeasel.configuration
  end

  #new
  describe '#new' do
    context 'with invalid arguments' do
      before do
        dictionary_cache_service.add_dictionary_reference(file: file)
      end

      context 'with invalid dictionary metadata' do
        let(:dictionary_metadata) { :wrong_type }

        it 'raises an error' do
          expect { subject }.to raise_error "Argument dictionary_metadata is not an Observable: #{dictionary_metadata.class}."
        end
      end

      context 'with an invalid dictionary' do
        let(:dictionary) { :wrong_type }

        it 'raises an error' do
          expect { subject }.to raise_error "Argument dictionary is not a Hash: #{dictionary.class}."
        end
      end
    end

    context 'with a valid arguments' do
      it 'instantiates without error' do
        expect { subject }.to_not raise_error
      end

      it 'initializes the necessary object attributes' do
        expect(subject.on?).to eq true
        expect(subject.off?).to eq false
        expect(subject.value).to eq configuration.max_invalid_words_bytesize
        expect(subject.value_exceeded?).to eq false
        expect(subject.current_invalid_word_bytesize).to eq 11
        expect(subject.cache_invalid_words?).to eq true
      end
    end

    context "with multiple #{described_class.name.split('::')[-1]} objects" do
      before do
        dictionary_cache_service.add_dictionary_reference(file: file)
      end

      context 'when sharing the same dictionary' do
        let(:subject2) { described_class.new dictionary_metadata }
        let(:dictionary_words_hash) do
          {
            'gene' => true,
            'was' => true,
            'here' => true,
            'bad-word10' => false,
          }
        end

        it 'they share the same metadata' do
          expect(subject.dictionary_metadata).to be subject2.dictionary_metadata
          expect(subject.current_invalid_word_bytesize).to eq 10
          expect(subject.current_invalid_word_bytesize).to eq subject2.current_invalid_word_bytesize
          dictionary_metadata.dictionary['bad-word02'] = false
          dictionary_metadata.refresh!
          expect(subject.current_invalid_word_bytesize).to eq 20
          expect(subject.current_invalid_word_bytesize).to eq subject2.current_invalid_word_bytesize
        end
      end
    end

    context 'with an invalid dictionary words Hash' do
      context 'when nil' do
        let(:dictionary_words_hash) {}

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context 'when not a Hash' do
        let(:dictionary_words_hash) { :not_an_array }

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
        subject.dictionary_metadata.dictionary['not-found'] = false
        subject.refresh!
      end.to change { subject.current_invalid_word_bytesize }
      .from(0).to(9)
    end
  end

  #to_hash
  describe '#to_hash' do
    context 'with the default argument value' do
      let(:expected_hash) do
        {
          described_class::METADATA_KEY => subject
        }
      end

      it 'returns the expected Hash' do
        expect(subject.to_hash).to eq expected_hash
      end
    end

    context 'with argument include_root: true' do
      let(:expected_hash) do
        {
          LittleWeasel::Metadata::DictionaryMetadata::METADATA_KEY =>
            {
              described_class::METADATA_KEY => subject
            }
        }
      end

      it 'returns the expected Hash with the root' do
        expect(subject.to_hash include_root: true).to eq expected_hash
      end
    end
  end

  #Update
  describe '#update' do
    context 'with an action NOT on the whitelist' do
      let(:action) { :bad_action! }

      it 'raises an error' do
        expect { subject.update(:action) }.to raise_error "Argument action is not in the actions_whitelist: #{action}"
      end
    end

    context 'with an action on the whitelist' do
      it 'carries out the requested action' do
        expect do
          dictionary['not-found']
        end.to change { subject.current_invalid_word_bytesize }
        .from(0).to(9)
      end
    end
  end
end
