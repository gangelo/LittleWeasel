# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::BlockResults do
  subject { described_class.new original_word_block: original_word_block }

  def ceate_word_results(word:, word_valid: false, word_cached: false, filters_matched: [], preprocessed_words: nil)
    create(:word_results, original_word: word, word_valid: word_valid, word_cached: word_cached, filters_matched: filters_matched, preprocessed_words: preprocessed_words)
  end

  let(:original_word_block) { 'Original word block' }

  # .new
  describe '.new' do
    it 'instantiates an object' do
      expect { subject }.not_to raise_error
    end

    it 'initializes #word_results to an empty Array' do
      expect(subject.word_results).to eq []
    end

    it 'initializes #original_word_block to the original_word_block argument passed' do
      expect(subject.original_word_block).to eq original_word_block
    end
  end

  # <<
  describe '<<' do
    context 'with an invalid argument' do
      it 'raises an error' do
        expect { subject << :not_a_word_results_object }.to raise_error(/Argument word_result is not a WordResults object/)
      end
    end

    context 'with a valid argument' do
      it 'adds the WordResults object to the #word_results Array' do
        expect { subject << ceate_word_results(word: 'word01') }.to \
          change { subject.word_results.count }.from(0).to(1)
      end
    end
  end

  # success?
  describe '#success?' do
    before do
      subject << ceate_word_results(word: 'word01', word_valid: true)
      subject << ceate_word_results(word: 'word02', word_valid: false, filters_matched: [:matched_filter])
    end

    context 'when all WordResults#successful? return true' do
      before do
        subject << ceate_word_results(word: 'word03', word_valid: false, filters_matched: [:matched_filter])
        subject << ceate_word_results(word: 'word04', word_valid: false, filters_matched: [:matched_filter])
      end

      it 'returns true' do
        expect(subject.success?).to be true
      end
    end

    context 'when any WordResults#word_valid? objects return false' do
      before do
        subject << ceate_word_results(word: 'word03', word_valid: false)
      end

      it 'returns false' do
        expect(subject.success?).to be false
      end
    end

    context 'when any WordResults#filter_match? objects return false' do
      before do
        subject << ceate_word_results(word: 'word03')
      end

      it 'returns false' do
        expect(subject.success?).to be false
      end
    end
  end

  # words_valid?
  describe '#words_valid?' do
    before do
      subject << ceate_word_results(word: 'word01', word_valid: true)
      subject << ceate_word_results(word: 'word02', word_valid: true)
    end

    context 'when all WordResults#word_valid? objects return true' do
      it 'returns true' do
        expect(subject.words_valid?).to be true
      end
    end

    context 'when any WordResults#word_valid? objects return false' do
      before do
        subject << ceate_word_results(word: 'word03', word_valid: false)
      end

      it 'returns false' do
        expect(subject.words_valid?).to be false
      end
    end
  end

  # filters_match?
  describe '#filters_match?' do
    before do
      subject << ceate_word_results(word: 'word01', filters_matched: [:matched_filter])
      subject << ceate_word_results(word: 'word02', filters_matched: [:matched_filter])
    end

    context 'when all WordResults#filters_match? objects return true' do
      it 'returns true' do
        expect(subject.filters_match?).to be true
      end
    end

    context 'when any WordResults#filters_match? objects return false' do
      before do
        subject << ceate_word_results(word: 'word03', filters_matched: [])
      end

      it 'returns false' do
        expect(subject.filters_match?).to be false
      end
    end
  end

  # preprocessed_words?
  describe '#preprocessed_words?' do
    before do
      subject << ceate_word_results(word: word, preprocessed_words: preprocessed_words)
    end

    let(:word) { 'word' }
    let(:preprocessed_words) { create(:preprocessed_words, original_word: word, with_word_processors: 1) }

    context 'when all WordResults#preprocessed_word? objects return true' do
      it 'returns true' do
        expect(subject.preprocessed_words?).to be true
      end
    end
  end

  # preprocessed_words_or_original_words
  describe '#preprocessed_words_or_original_words' do
    context 'with all preprocessed words' do
      before do
        subject << ceate_word_results(word: words[0], preprocessed_words: preprocessed_words[0])
        subject << ceate_word_results(word: words[1], preprocessed_words: preprocessed_words[1])
      end

      let(:words) { %w[word1 word2] }
      let(:preprocessed_words) do
        [
          create(:preprocessed_words, original_word: words[0], with_word_processors: 1),
          create(:preprocessed_words, original_word: words[1], with_word_processors: 2)
        ]
      end

      it 'returns all the preprocessed words' do
        expect(subject.preprocessed_words_or_original_words).to eq %w[word1-0 word2-0-1]
      end
    end

    context 'with all original words' do
      before do
        subject << ceate_word_results(word: words[0])
        subject << ceate_word_results(word: words[1])
      end

      let(:words) { %w[word1 word2] }

      it 'returns all the original words' do
        expect(subject.preprocessed_words_or_original_words).to eq %w[word1 word2]
      end
    end

    context 'with mixed original words and preprocessed words' do
      before do
        subject << ceate_word_results(word: words[0], word_valid: true)
        subject << ceate_word_results(word: words[1], word_valid: true, preprocessed_words: preprocessed_words[0])
        subject << ceate_word_results(word: words[2], word_valid: true)
        subject << ceate_word_results(word: words[3], word_valid: true, preprocessed_words: preprocessed_words[1])
      end

      let(:words) { %w[word0 word1 word2 word3] }
      let(:preprocessed_words) do
        [
          create(:preprocessed_words, original_word: words[1], with_word_processors: 1),
          create(:preprocessed_words, original_word: words[3], with_word_processors: 2)
        ]
      end

      it 'returns all the original and preprocessed words' do
        expect(subject.preprocessed_words_or_original_words).to eq %w[word0 word1-0 word2 word3-0-1]
      end
    end
  end

  # words_cached?
  describe '#words_cached?' do
    before do
      subject << ceate_word_results(word: words[0])
      subject << ceate_word_results(word: words[1])
      subject << ceate_word_results(word: words[2])
      subject << ceate_word_results(word: words[3])
    end

    let(:words) { %w[word1 word2 word3 word4] }

    context 'when all the words are cached' do
      before do
        allow_any_instance_of(LittleWeasel::WordResults).to receive(:word_cached?).and_return(true)
      end

      it 'returns true' do
        expect(subject.words_cached?).to be true
      end
    end

    context 'when some of the words are cached' do
      before do
        allow(subject.word_results[0]).to receive(:word_cached?).and_return(false)
        allow(subject.word_results[1]).to receive(:word_cached?).and_return(true)
        allow(subject.word_results[2]).to receive(:word_cached?).and_return(false)
        allow(subject.word_results[3]).to receive(:word_cached?).and_return(true)
      end

      it 'returns false' do
        expect(subject.words_cached?).to be false
      end
    end

    context 'when NONE of the words are cached' do
      before do
        allow_any_instance_of(LittleWeasel::WordResults).to receive(:word_cached?).and_return(false)
      end

      it 'returns false' do
        expect(subject.words_cached?).to be false
      end
    end
  end
end
