# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel do
  subject do
    described_class.configure { |config| }
    described_class.configuration
  end

  context 'default configurable settings' do
    describe '#dictionaries' do
      it 'has has no dictionaries by default' do
        expect(subject.dictionaries).to eq({})
      end
    end

    describe '#ignore_numerics' do
      it 'ignores numerics by default' do
        expect(subject.ignore_numerics).to be true
      end
    end

    describe '#language' do
      it 'set to nil by default' do
        expect(subject.language).to eq nil
      end
    end

    describe '#region' do
      it 'set to nil by default' do
        expect(subject.region).to eq nil
      end
    end

    describe '#numeric_regex' do
      it 'provides a regex by default' do
        expect(subject.numeric_regex).to eq(/^[-+]?[0-9]?(\.[0-9]+)?$+/)
      end
    end

    describe '#max_dictionary_file_megabytes' do
      it 'set to 4 by default' do
        expect(subject.max_dictionary_file_megabytes).to eq 4
      end
    end

    describe '#max_invalid_words_bytesize' do
      it 'set to 25_000 by default' do
        expect(subject.max_invalid_words_bytesize).to eq 25_000
      end
    end

    describe '#metadata_observers=' do
      it 'set to an Array with InvalidWordsMetadata by default' do
        expect(subject.metadata_observers).to eq [LittleWeasel::Metadata::InvalidWords::InvalidWordsMetadata]
      end
    end

    describe '#single_character_words' do
      it 'provides a regex by default' do
        expect(subject.single_character_words).to eq(/[aAI]/)
      end
    end

    describe '#strip_whitespace' do
      it 'strips whitespace by default' do
        expect(subject.strip_whitespace).to be true
      end
    end

    describe '#word_regex' do
      it 'provides a regex by default' do
        expect(subject.word_regex).to eq(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
      end
    end
  end

  #.configuration
  describe '.configuration' do
    context 'when passing a block' do
      subject do
        described_class.configure do |config|
          config.dictionaries = :dictionaries
          config.ignore_numerics = :ignore_numerics
          config.language = :language
          config.max_dictionary_file_megabytes = max_dictionary_file_megabytes
          config.metadata_observers = metadata_observers
          config.numeric_regex = :numeric_regex
          config.region = :region
          config.single_character_words = :single_character_words
          config.strip_whitespace = :strip_whitespace
          config.word_regex = :word_regex
        end
        described_class.configuration
      end

      let(:max_dictionary_file_megabytes) { 1_222_333 }
      let(:metadata_observers) { %i(observer0 observer1) }

      describe '#dictionaries=' do
        it 'sets the value' do
          expect(subject.dictionaries).to eq :dictionaries
        end
      end

      describe '#ignore_numerics=' do
        it 'sets the value' do
          expect(subject.ignore_numerics).to eq :ignore_numerics
        end
      end

      describe '#language=' do
        it 'sets the value' do
          expect(subject.language).to eq :language
        end
      end

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

      describe '#numeric_regex=' do
        it 'sets the value' do
          expect(subject.numeric_regex).to eq :numeric_regex
        end
      end

      describe '#region=' do
        it 'sets the value' do
          expect(subject.region).to eq :region
        end
      end

      describe '#single_character_words=' do
        it 'sets the value' do
          expect(subject.single_character_words).to eq :single_character_words
        end
      end

      describe '#strip_whitespace=' do
        it 'sets the value' do
          expect(subject.strip_whitespace).to eq :strip_whitespace
        end
      end

      describe '#word_regex=' do
        it 'sets the value' do
          expect(subject.word_regex).to eq :word_regex
        end
      end
    end
  end
end
