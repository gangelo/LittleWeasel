# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryServiceDeprecated do
  subject { described_class }

  let(:locale) { { language: :en, region: :us, tag: :tagged } }
  let(:dictionary_key) { LittleWeasel::DictionaryKey.new(**locale) }
  let(:dictionary_cache) { { dictionary_cache: true } }

  #new
  describe '#new' do
    describe 'with valid arguments' do
      context 'with a valid dictionary key and dictionary cache' do
        it 'instantiates without error' do
          expect { subject.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }.to_not raise_error
        end
      end
    end

    context 'with invalid arguments' do
      describe 'with an invalid dictionary cache' do
        context 'when nil' do
          it 'raises an error' do
            expect { subject.new(dictionary_key: dictionary_key, dictionary_cache: nil) }.to raise_error 'Argument dictionary_cache is not a valid Hash'
          end
        end

        context 'when not a Hash' do
          it 'raises an error' do
            expect { subject.new(dictionary_key: dictionary_key, dictionary_cache: :not_a_hash) }.to raise_error 'Argument dictionary_cache is not a valid Hash'
          end
        end
      end

      describe 'with an invalid dictionary key' do
        context 'when nil' do
          it 'raises an error' do
            expect { subject.new(dictionary_key: nil, dictionary_cache: dictionary_key) }.to raise_error 'Argument dictionary_key is not a DictionaryKey object'
          end
        end

        context 'when not a DictionaryKey' do
          it 'raises an error' do
            expect { subject.new(dictionary_key: :not_a_dictionary_key, dictionary_cache: dictionary_key) }.to raise_error 'Argument dictionary_key is not a DictionaryKey object'
          end
        end
      end
    end
  end
end
