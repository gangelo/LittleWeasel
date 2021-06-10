# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Metadata::MetadataObserverable, type: :module do
  MetadataObserverable = described_class

  subject do
    Class.new do
      include MetadataObserverable
    end.new
  end

  describe '#observe?' do
    it 'returns false by default' do
      expect(subject.observe?).to eq false
    end
  end

  describe '#update' do
    it 'raises an error if not overridden' do
      expect { subject.update :action, args: :args }.to raise_error LittleWeasel::Errors::MustOverrideError
    end
  end

  describe '#actions_whitelist' do
    it 'returns an Array with :init and :refresh Symbols by default' do
      expect(subject.actions_whitelist).to eq %i[init refresh]
    end
  end
end
