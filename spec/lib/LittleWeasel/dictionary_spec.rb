# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Dictionary do
  include_context 'dictionary keys'

  subject { create(:dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_words: dictionary_words) }

  before do
    LittleWeasel.configure { |_config| }
    create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: true)
  end

  let(:dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:dictionary_cache) { {} }
  let(:dictionary_words) { %w(a b c d e f g h i j k l m n o p q r s t u v w x y z) }

  shared_examples 'the dictionary_id is set' do
    xit 'sets the dictionary_id' do
      expect(subject.dictionary_id).to_not be_nil
    end
  end

  shared_examples 'the dictionary_id returns the right value' do
    xit 'returns the expected dictionary_id' do
      expect(subject.dictionary_id).to_not be_negative
    end
  end

  #.new
  describe '.new' do
    it_behaves_like 'the dictionary_id is set'
    it_behaves_like 'the dictionary_id returns the right value'

    context 'with a valid dictionary words Array' do
      it 'instantiates without error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with an invalid dictionary words Array' do
      context 'when nil' do
        let(:dictionary_words) {}

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context 'when not an Array' do
        let(:dictionary_words) { :not_an_array }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end

  #dictionary_id
  describe '#dictionary_id' do
    it_behaves_like 'the dictionary_id is set'
    it_behaves_like 'the dictionary_id returns the right value'
  end

  #key
  describe '#key' do
    it 'returns the expected key' do
      expect(subject.key).to eq dictionary_key.key
    end
  end

  #count
  describe '#count' do
    it 'returns the expected count' do
      expect(subject.count).to eq dictionary_words.count
    end
  end

  #[]
  describe '#[]' do
    context 'when searching for words in the dictionary' do
      context 'when the word is found' do
        it 'returns true' do
          expect(subject['t']).to eq true
        end
      end

      context 'when the word is not found' do
        it 'returns false' do
          expect(subject['not-found']).to eq false
        end
      end
    end
  end

  # Configuration
  xcontext 'configuration options that alter behavior' do
    context 'when max_invalid_words_bytesize? is true' do
      before do
        LittleWeasel.configure { |config| max_invalid_words_bytesize = 25_000 }
      end

      context 'when a word is not found' do
        context 'when the max_invalid_words_bytesize threashold has not been exceeded' do
          let(:from_count) { dictionary_words.count }
          let(:to_count) { from_count + 1 }

          it 'adds the word to the cache' do
            expect { subject['not-found'] }.to change { subject.count }.from(from_count).to(to_count)
          end
        end
      end
    end
  end
end
