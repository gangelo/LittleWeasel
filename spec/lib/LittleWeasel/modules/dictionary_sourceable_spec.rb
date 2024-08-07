# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::DictionarySourceable, type: :module do
  subject { MockDictionarySourceable.new(dictionary_memory_source) }

  DictionarySourceable = described_class

  class MockDictionarySourceable
    include DictionarySourceable

    def initialize(dictionary_source)
      self.dictionary_source = dictionary_source
    end
  end

  let(:dictionary_memory_source) { described_class.memory_source }
  let(:dictionary_file_source) { language_dictionary_path language: :en }

  # .MEMORY_SOURCE
  describe '::MEMORY_SOURCE' do
    it 'returns the memory source prefix' do
      expect(described_class::MEMORY_SOURCE).to eq '*'
    end
  end

  # .memory_source
  describe '.memory_source' do
    it 'returns a new memory source' do
      expect(described_class.memory_source).to be_truthy
    end
  end

  # .file_source?
  describe '.file_source?' do
    context 'when dictionary_source is a file source' do
      it 'returns truthy' do
        expect(described_class).to be_file_source(dictionary_file_source)
      end
    end

    context 'when dictionary_source is NOT a file source' do
      it 'returns falsey' do
        expect(described_class).not_to be_file_source(dictionary_memory_source)
      end
    end
  end

  # .memory_source?
  describe '.memory_source?' do
    context 'when dictionary_source is a memory source' do
      it 'returns truthy if argument is a valid memory source' do
        expect(described_class).to be_memory_source('*12345678')
        expect(described_class).to be_memory_source('*abcdef00')
        expect(described_class).to be_memory_source('*ABCDEF00')
        expect(described_class).to be_memory_source('*aBcDeF00')
      end

      it 'returns falsey if argument is NOT a memory source' do
        expect(described_class).not_to be_memory_source('*123456789')
        expect(described_class).not_to be_memory_source('*abcdefg0')
        expect(described_class).not_to be_memory_source('*ABCDEFG0')
        expect(described_class).not_to be_memory_source('*aBcDeFg0')
        expect(described_class).not_to be_memory_source('$12345678')

        expect(described_class).not_to be_memory_source('123456789')
        expect(described_class).not_to be_memory_source('abcdefg0')
        expect(described_class).not_to be_memory_source('ABCDEFG0')
        expect(described_class).not_to be_memory_source('aBcDeFg0')
        expect(described_class).not_to be_memory_source('123456789')
      end
    end

    context 'when dictionary_source is a file source' do
      it 'returns falsey' do
        expect(described_class).not_to be_memory_source(dictionary_file_source)
      end
    end
  end
end
