# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::DictionarySourceable, type: :module do

  #.MEMORY_SOURCE
  describe '::MEMORY_SOURCE' do
    it 'returns the memory source value' do
      expect(described_class::MEMORY_SOURCE).to eq 'memory'
    end
  end

  #.memory_source?
  describe '.memory_source?' do
    it 'returns true if argument is a memory source' do
      expect(described_class.memory_source? 'memory').to eq true
    end

    it 'returns false if argument is NOT a memory source' do
      expect(described_class.memory_source? 'x').to eq false
    end
  end
end
