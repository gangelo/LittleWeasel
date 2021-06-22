# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Dictionary do
  include_context 'dictionary keys'
  include_context 'mock word filters'

  subject { create(:dictionary, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_words: dictionary_words, word_filters: word_filters) }

  before(:each) { LittleWeasel.configure { |config| config.reset } }
  before { dictionary_cache_service }

  let(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: dictionary_key.key) }
  let(:dictionary_key) { dictionary_key_for(language: :en, region: :us, tag: :big) }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:dictionary_file_path) { dictionary_path_for(file_name: dictionary_key.key) }
  let(:dictionary_words) { dictionary_words_for(dictionary_file_path: dictionary_file_path) }
  let(:word_filters) {}

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

    describe 'word_filter:' do
      context 'when argument word_filters is nil' do
        it 'no word filters will be used' do
          expect(subject.word_filters).to be_blank
        end
      end

      context 'when argument word_filters is an empty Array ([])' do
        let(:word_filters) { [] }

        it 'no word filters will be used' do
          expect(subject.word_filters.count).to eq 0
        end
      end

      context 'when argument word_filters is NOT nil' do
        let(:word_filters) { [WordFilter01.new, WordFilter02.new] }

        it 'the dictionary will use the word filters passed' do
          expect(subject.word_filters.count).to eq 2
          expect(subject.word_filters).to include(a_kind_of(WordFilter01))
          expect(subject.word_filters).to include(a_kind_of(WordFilter02))
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

  #detached?
  describe '#detached?' do
    before do
      subject
    end

    let(:dictionary_cache_service) { create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_reference: dictionary_key.key, load: true) }

    context 'when the dictionary object is in the dictionary cache' do
      it 'returns false' do
        dictionary_cache_service
        expect(dictionary_cache_service.dictionary_object?).to eq true
        expect(subject.detached?).to eq false
      end
    end

    context 'when the dictionary object is NOT in the dictionary cache' do
      before do
        dictionary_cache_service
        dictionary_killer_service = create(:dictionary_killer_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata)
        dictionary_killer_service.execute
      end

      it 'returns true' do
        expect(dictionary_cache_service.dictionary_object?).to eq false
        expect(subject.detached?).to eq true
      end
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
      subject.word_results('badword')
    end

    it 'returns the count of all valid words' do
      expect(subject.count).to eq dictionary_words.count
    end
  end

  #count_all_words
  describe '#count_all_words' do
    before do
      subject.word_results('badword')
    end

    it 'returns the count of all valid and invalid words' do
      expect(subject.count_all_words).to eq dictionary_words.count + 1
    end
  end

  #count_invalid_words
  describe '#count_invalid_words' do
    before do
      subject.word_results('badword')
    end

    it 'returns the count of all invalid words' do
      expect(subject.count_invalid_words).to eq 1
    end
  end

  #word_results
  describe '#word_results' do
    context 'when argument word is INVALID' do
      context 'when not a String' do
        let(:word) { :not_a_string }

        it 'raises an error' do
          expect { subject.word_results(word) }.to raise_error "Argument word is not a String: #{word.class}"
        end
      end
    end

    context 'when searching for words in the dictionary' do
      context 'when the word is found' do
        it 'returns true' do
          expect(subject.word_results('dog').success?).to eq true
        end
      end

      context 'when the word is not found' do
        it 'returns false' do
          expect(subject.word_results('badword').success?).to eq false
        end
      end
    end
  end

  #block_results
  describe '#block_results' do
    context 'when nil is passed' do
      it 'does something'
    end

    context 'when an empty String is passed' do
      it 'does something'
    end

    context 'when a block with all valid words is passed' do
      subject do
        create(:dictionary,
          dictionary_key: dictionary_key,
          dictionary_cache: dictionary_cache,
          dictionary_words: dictionary_words,
          word_filters: word_filters).block_results word_block
      end

      let(:word_block) do
        "I was born in 1964; before your time, I'm afraid!"
      end

      it 'does something'
    end

    context 'when a block with some INVALID words are passed' do
      it 'does something'
    end
  end

  # Configuration
  context 'configuration options that alter behavior' do
    context 'when max_invalid_words_bytesize? is true' do
      context 'when a word is not found' do
        context 'when the max_invalid_words_bytesize threashold has not been exceeded' do
          it 'adds the word to the cache' do
            expect { subject.word_results('badword') }.to change { subject.count_all_words }.by(1)
          end
        end

        context 'when the max_invalid_words_bytesize threashold HAS been exceeded' do
          before do
            LittleWeasel.configure { |config| config.max_invalid_words_bytesize = 30 }
          end

          it 'does NOT add the word to the cache' do
            expect do
              subject.word_results('IWillBeCached01')
              subject.word_results('IWillBeCached02')
              subject.word_results('IWontBeCached01')
              subject.word_results('IWontBeCached02')
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
          subject.word_results('IWillBeCached01')
          subject.word_results('IWillBeCached02')
          subject.word_results('IWontBeCached01')
          subject.word_results('IWontBeCached02')
        end.to change { subject.count_all_words }.by(0)
      end
    end
  end
end
