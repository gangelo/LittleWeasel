# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Dictionary do
  include_context 'dictionary keys'

  subject { create(:dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_words: dictionary_words) }

  before do
    create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: true)
  end

  before(:each) do
    LittleWeasel.configure { |config| config.max_invalid_words_bytesize = 25_000 }
  end

  let(:dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:dictionary_cache) { {} }
  let(:dictionary_file_path) { dictionary_path_for(file_name: dictionary_key.key) }
  let(:dictionary_words) { dictionary_words_for(dictionary_file_path: dictionary_file_path) }

  #.new
  describe '.new' do
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

  #.to_hash
  describe '.to_hash' do
    let(:expected_hash) do
      {
        'this' => true,
        'is' => true,
        'a' => true,
        'test' => true
      }
    end

    it 'returns a Hash of dictionary words' do
      expect(described_class.to_hash(dictionary_words: %w(this is a test))).to eq expected_hash
    end
  end

  #key
  describe '#key' do
    it 'returns the expected key' do
      expect(subject.key).to eq dictionary_key.key
    end
  end

  #count
  describe '#count' do
    before do
      subject.word_valid?('badword')
    end

    it 'returns the count of all valid words' do
      expect(subject.count).to eq dictionary_words.count
    end
  end

  #count_all_words
  describe '#count_all_words' do
    before do
      subject.word_valid?('badword')
    end

    it 'returns the count of all valid and invalid words' do
      expect(subject.count_all_words).to eq dictionary_words.count + 1
    end
  end

  #count_invalid_words
  describe '#count_invalid_words' do
    before do
      subject.word_valid?('badword')
    end

    it 'returns the count of all invalid words' do
      expect(subject.count_invalid_words).to eq 1
    end
  end

  #word_valid?
  describe '#word_valid?' do
    context 'when searching for words in the dictionary' do
      context 'when the word is found' do
        it 'returns true' do
          expect(subject.word_valid? 'dog').to eq true
        end
      end

      context 'when the word is not found' do
        it 'returns false' do
          expect(subject.word_valid? 'badword').to eq false
        end
      end
    end
  end

  # Configuration
  context 'configuration options that alter behavior' do
    context 'when max_invalid_words_bytesize? is true' do
      context 'when a word is not found' do
        context 'when the max_invalid_words_bytesize threashold has not been exceeded' do
          it 'adds the word to the cache' do
            expect { subject.word_valid?('badword') }.to change { subject.count_all_words }.by(1)
          end
        end

        context 'when the max_invalid_words_bytesize threashold HAS been exceeded' do
          before do
            LittleWeasel.configure { |config| config.max_invalid_words_bytesize = 30 }
          end

          it 'does NOT add the word to the cache' do
            expect do
              subject.word_valid?('IWillBeCached01')
              subject.word_valid?('IWillBeCached02')
              subject.word_valid?('IWontBeCached01')
              subject.word_valid?('IWontBeCached02')
            end.to change { subject.count_all_words }.by(2)
          end
        end
      end
    end

    context 'when max_invalid_words_bytesize? is false' do
      before do
        LittleWeasel.configure { |config| config.max_invalid_words_bytesize = 0 }
      end

      it 'does NOT add the word to the cache' do
        expect do
          subject.word_valid?('IWillBeCached01')
          subject.word_valid?('IWillBeCached02')
          subject.word_valid?('IWontBeCached01')
          subject.word_valid?('IWontBeCached02')
        end.to change { subject.count_all_words }.by(0)
      end
    end
  end
end
