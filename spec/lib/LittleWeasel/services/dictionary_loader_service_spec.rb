# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryLoaderService do
  subject { described_class.new dictionary_array }

  before do
    LittleWeasel.configure { |_config| }
  end

  let(:dictionary_array) { %w(gene angelo was here) }

  #execute
  describe '#execute' do
    context 'when the dictionary is cached' do
      it 'loads the dictionary from the dictionary cache and returns the Dictionary'
    end

    context 'when the dictionary is not cached' do
      it 'loads the dictionary file and returns the Dictionary'
    end
  end
end
