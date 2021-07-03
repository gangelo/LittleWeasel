# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Metadata::Metadatable, type: :module do
  Metadatable = described_class

  subject do
    Class.new do
      include Metadatable

      def update_dictionary_metadata_test
        update_dictionary_metadata value: :value
      end
    end.new
  end

  describe '#init' do
    it 'raises an error if not overridden' do
      expect { subject.init }.to raise_error LittleWeasel::Errors::MustOverrideError
    end
  end

  describe '#refresh' do
    it 'raises an error if not overridden' do
      expect { subject.refresh }.to raise_error LittleWeasel::Errors::MustOverrideError
    end
  end

  describe '#update_dictionary_metadata' do
    it 'raises an error if not overridden' do
      expect { subject.update_dictionary_metadata_test }.to raise_error LittleWeasel::Errors::MustOverrideError
    end
  end
end
