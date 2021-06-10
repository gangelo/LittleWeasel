# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::ClassNameToSymbol, type: :module do
  ClassNameToSymbol = described_class

  subject do
    module TestModule
      class TestMeUp
        include ClassNameToSymbol
      end
    end
  end

  describe '#to_sym' do
    it 'returns the class name as a snake-case Symbol with namespaces removed' do
      expect(subject.new.to_sym).to eq :test_me_up
    end
  end
end
