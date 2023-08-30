# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::WordResults do
  subject do
    create(:word_results,
      original_word: original_word,
      filters_matched: filters_matched,
      preprocessed_words: preprocessed_words,
      word_cached: word_cached,
      word_valid: word_valid)
  end

  let(:original_word) { 'original-word' }
  let(:word) { original_word }
  let(:filters_matched) { [] }
  let(:preprocessed_words) {}
  let(:word_cached) { false }
  let(:word_valid) { false }

  # .new
  describe '.new' do
    context 'with valid arguments' do
      it 'instantiates the object' do
        expect { subject }.not_to raise_error
      end
    end

    context 'with INVALID arguments' do
      context 'when argument original_word is invalid' do
        let(:original_word) {}

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument original_word is not a String/)
        end
      end

      context 'when argument filters_matched is invalid' do
        let(:filters_matched) {}

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument filters_matched is not an Array/)
        end
      end

      context 'when argument preprocessed_words is invalid' do
        let(:preprocessed_words) { :invalid }

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument preprocessed_words does not respond to/)
        end
      end

      context 'when argument word_cached is invalid' do
        let(:word_cached) {}

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument word_cached is not true or false/)
        end
      end

      context 'when argument word_valid is invalid' do
        let(:word_valid) {}

        it 'raises an error' do
          expect { subject }.to raise_error(/Argument word_valid is not true or false/)
        end
      end
    end
  end

  # original_word=
  describe '#original_word=' do
    let(:changed_value) { "#{original_word}-changed" }

    it 'sets @original_word' do
      expect(subject.original_word).to eq original_word
      subject.original_word = changed_value
      expect(subject.original_word).to eq changed_value
    end
  end

  # filters_matched=
  describe '#filters_matched=' do
    let(:filters_matched) { [:filters_matched] }
    let(:changed_value) { [:filters_matched_changed] }

    it 'sets @filters_matched' do
      expect(subject.filters_matched).to eq filters_matched
      subject.filters_matched = changed_value
      expect(subject.filters_matched).to eq changed_value
    end
  end

  # word_cached=
  describe '#word_cached=' do
    let(:changed_value) { !word_cached }

    it 'sets @word_cached' do
      expect(subject.word_cached).to eq word_cached
      subject.word_cached = changed_value
      expect(subject.word_cached).to eq changed_value
    end
  end

  # word_valid=
  describe '#word_valid=' do
    let(:changed_value) { !word_valid }

    it 'sets @word_valid' do
      expect(subject.word_valid).to eq word_valid
      subject.word_valid = changed_value
      expect(subject.word_valid).to eq changed_value
    end
  end

  # preprocesed_words=
  describe '#preprocesed_words=' do
    let(:changed_value) do
      create(:preprocessed_words, with_word_processors: 2, original_word: original_word)
    end

    it 'sets @preprocesed_words' do
      expect { subject.preprocessed_words = changed_value }.to \
        change(subject, :preprocessed_words)
        .from(preprocessed_words)
        .to(changed_value)
    end
  end

  # success?
  describe '#success?' do
    context 'when #filter_match? is false AND #word_valid? is false' do
      before do
        allow(subject).to receive_messages(filter_match?: false, word_valid?: false)
      end

      it 'returns false' do
        expect(subject.success?).to be false
      end
    end

    context 'when #filter_match? is true OR #word_valid? is true' do
      context 'when #filter_match? is true' do
        before do
          allow(subject).to receive_messages(filter_match?: true, word_valid?: false)
        end

        it 'returns true' do
          expect(subject.success?).to be true
        end
      end

      context 'when #word_valid? is true' do
        before do
          allow(subject).to receive_messages(filter_match?: false, word_valid?: true)
        end

        it 'returns true' do
          expect(subject.success?).to be true
        end
      end
    end
  end

  # filter_match?
  describe '#filter_match?' do
    describe '#when filters_matched is present' do
      let(:filters_matched) { [:matched_filter] }

      it 'returns true' do
        expect(subject.filter_match?).to be true
      end
    end

    describe '#when filters_matched is NOT present' do
      it 'returns false' do
        expect(subject.filter_match?).to be false
      end
    end
  end

  # word_cached?
  describe '#word_cached?' do
    describe '#when word_cached is true' do
      let(:word_cached) { true }

      it 'returns true' do
        expect(subject.word_cached?).to be true
      end
    end

    describe '#when word_cached is false' do
      it 'returns false' do
        expect(subject.word_cached?).to be false
      end
    end
  end

  # word_valid?
  describe '#word_valid?' do
    describe '#when word_valid is true' do
      let(:word_valid) { true }

      it 'returns true' do
        expect(subject.word_valid?).to be true
      end
    end

    describe '#when word_valid is false' do
      it 'returns false' do
        expect(subject.word_valid?).to be false
      end
    end
  end

  # preprocessed_word?
  describe '#preprocessed_word?' do
    subject do
      create(:word_results,
        original_word: original_word,
        filters_matched: [],
        preprocessed_words: preprocessed_words,
        word_cached: false,
        word_valid: false)
    end

    context 'when #preprocessed_word is NOT nil' do
      let(:preprocessed_words) do
        create(:preprocessed_words, with_word_processors: 2)
      end

      it 'returns true' do
        expect(subject.preprocessed_word?).to be true
      end
    end

    context 'when #preprocessed_word is nil' do
      let(:preprocessed_words) do
        create(:preprocessed_words)
      end

      it 'returns false' do
        expect(subject.preprocessed_word?).to be false
      end
    end
  end

  # preprocessed_word_or_original_word
  describe '#preprocessed_word_or_original_word' do
    let(:original_word) { 'word' }

    context 'when the word has been preprocessed' do
      let(:preprocessed_words) do
        create(:preprocessed_words,
          original_word: original_word,
          with_word_processors: 2)
      end

      it 'returns #preprocesed_word' do
        expect(subject.preprocessed_word_or_original_word).to eq 'word-0-1'
      end
    end

    context 'when the word has NOT been preprocessed' do
      it 'returns #original_word' do
        expect(subject.preprocessed_word_or_original_word).to eq original_word
      end
    end
  end
end
