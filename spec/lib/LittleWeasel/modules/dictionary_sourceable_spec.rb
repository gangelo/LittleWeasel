# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::DictionarySourceable, type: :module do

  #.MEMORY_SOURCE
  describe '::MEMORY_SOURCE' do
    it 'returns the memory source value' do
      expect(described_class::MEMORY_SOURCE).to eq '*'
    end
  end

  #.memory_source
  describe '.memory_source' do
    it 'returns a new memory source' do
      expect(described_class.memory_source?(described_class.memory_source)).to be_truthy
    end
  end

  #.memory_source?
  describe '.memory_source?' do
    it 'returns truthy if argument is a valid memory source' do
      expect(described_class.memory_source? '*12345678').to be_truthy
      expect(described_class.memory_source? '*abcdef00').to be_truthy
      expect(described_class.memory_source? '*ABCDEF00').to be_truthy
      expect(described_class.memory_source? '*aBcDeF00').to be_truthy
    end

    it 'returns falsey if argument is NOT a memory source' do
      expect(described_class.memory_source? '*123456789').to be_falsey
      expect(described_class.memory_source? '*abcdefg0').to be_falsey
      expect(described_class.memory_source? '*ABCDEFG0').to be_falsey
      expect(described_class.memory_source? '*aBcDeFg0').to be_falsey
      expect(described_class.memory_source? '$12345678').to be_falsey

      expect(described_class.memory_source? '123456789').to be_falsey
      expect(described_class.memory_source? 'abcdefg0').to be_falsey
      expect(described_class.memory_source? 'ABCDEFG0').to be_falsey
      expect(described_class.memory_source? 'aBcDeFg0').to be_falsey
      expect(described_class.memory_source? '123456789').to be_falsey
    end
  end
end
