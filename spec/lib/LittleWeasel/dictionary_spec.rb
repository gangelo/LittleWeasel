# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Dictionary do
  subject { described_class.new dictionary_array }

  before do
    LittleWeasel.configure { |_config| }
  end

  let(:dictionary_array) { %w(a b c d e f g h i j k l m n o p q r s t u v w x y z) }

  #new
  describe '#new' do
    context 'with a valid dictionary words Array' do
      it 'instantiates without error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with an invalid dictionary words Array' do
      context 'when nil' do
        let(:dictionary_array) {}

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context 'when not an Array' do
        let(:dictionary_array) { :not_an_array }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError
        end
      end
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
  context 'configuration options that alter behavior' do
    context 'when max_invalid_words_bytesize? is true' do
      before do
        LittleWeasel.configure { |config| max_invalid_words_bytesize = 25_000 }
      end

      context 'when a word is not found' do
        context 'when the max_invalid_words_bytesize threashold has not been exceeded' do
          let(:from_count) { dictionary_array.count }
          let(:to_count) { from_count + 1 }

          it 'adds the word to the cache' do
            expect { subject['not-found'] }.to change { subject.count }.from(from_count).to(to_count)
          end
        end
      end
    end
  end
end
