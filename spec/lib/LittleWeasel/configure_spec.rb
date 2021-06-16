# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel do
  subject do
    described_class.configure { |config| }
    described_class.configuration
  end

  context 'default configurable settings' do
    describe '#max_dictionary_file_megabytes' do
      it 'set to 5 by default' do
        expect(subject.max_dictionary_file_megabytes).to eq 5
      end
    end

    describe '#max_invalid_words_bytesize' do
      it 'set to 25_000 by default' do
        expect(subject.max_invalid_words_bytesize).to eq 25_000
      end
    end

    describe '#metadata_observers=' do
      it 'set to an Array with InvalidWordsMetadata by default' do
        expect(subject.metadata_observers).to eq [
          LittleWeasel::Metadata::InvalidWordsMetadata
        ]
      end
    end

    describe '#word_filters=' do
      it 'set to an Array with default word filters' do
        expect(subject.word_filters).to eq [
          LittleWeasel::Filters::NumericFilter,
          LittleWeasel::Filters::SingleCharacterWordFilter
        ]
      end
    end

    describe '#word_preprocessors=' do
      it 'set to an Array with default word preprocessors' do
        expect(subject.word_preprocessors).to eq []
      end
    end
  end

  #.configuration
  describe '.configuration' do
    context 'when passing a block' do
      subject do
        described_class.configure do |config|
          config.max_dictionary_file_megabytes = max_dictionary_file_megabytes
          config.metadata_observers = metadata_observers
          config.word_filters = word_filters
          config.word_preprocessors = word_preprocessors
        end
        described_class.configuration
      end

      let(:max_dictionary_file_megabytes) { 1_222_333 }
      let(:metadata_observers) { %i(observer0 observer1) }
      let(:word_filters) { %i(word_filter0 word_filter1) }
      let(:word_preprocessors) { %i(word_preprocessors0 word_preprocessors1) }

      describe '#max_dictionary_file_megabytes=' do
        it 'sets the value' do
          expect(subject.max_dictionary_file_megabytes).to eq max_dictionary_file_megabytes
        end
      end

      describe '#metadata_observers=' do
        it 'sets the value' do
          expect(subject.metadata_observers).to eq metadata_observers
        end
      end

      describe '#word_filters=' do
        it 'sets the value' do
          expect(subject.word_filters).to eq word_filters
        end
      end

      describe '#word_preprocessors=' do
        it 'sets the value' do
          expect(subject.word_preprocessors).to eq word_preprocessors
        end
      end
    end
  end
end
