# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Filters::WordFilterValidatable, type: :module do
  WordFilterValidatable = described_class

  class Subject
    include WordFilterValidatable
  end

  subject { Subject.new }

  let(:filter_class) do
    filter = Class.new do
      def filter_on?; end
      def filter_off?; end
      def filter_on; end
      def filter_on=; end
      def filter_match?; end
      def self.filter_match?; end
    end
    filter
  end

  let(:numeric_filter) do
    filter_class.new
  end
  let(:expected_error_message) { "Argument word_filter does not quack right: #{numeric_filter.class}" }

  #validate_word_filter
  describe '#validate_word_filter' do
    context 'when argument word_filter quacks correctly' do
      it 'does not raise an error' do
        expect { subject.validate_word_filter(word_filter: numeric_filter) }.to_not raise_error
      end
    end

    context 'when argument word_filter DOES NOT quack correctly to the right instance methods' do
      context 'when word_filter does not respond to #filter_on?' do
        before { numeric_filter.instance_eval("undef #{method_to_check}") }
        let(:method_to_check) { :filter_on? }

        it 'raises an error' do
          expect { subject.validate_word_filter(word_filter: numeric_filter) }.to raise_error \
            expected_error_message
        end
      end

      context 'when word_filter does not respond to #filter_on' do
        before { numeric_filter.instance_eval("undef #{method_to_check}") }
        let(:method_to_check) { :filter_on }

        it 'raises an error' do
          expect { subject.validate_word_filter(word_filter: numeric_filter) }.to raise_error \
            expected_error_message
        end
      end

      context 'when word_filter does not respond to #filter_on=' do
        before { numeric_filter.instance_eval("undef #{method_to_check}") }
        let(:method_to_check) { :filter_on= }

        it 'raises an error' do
          expect { subject.validate_word_filter(word_filter: numeric_filter) }.to raise_error \
            expected_error_message
        end
      end

      context 'when word_filter does not respond to #filter_match?' do
        before { numeric_filter.instance_eval("undef #{method_to_check}") }
        let(:method_to_check) { :filter_match? }

        it 'raises an error' do
          expect { subject.validate_word_filter(word_filter: numeric_filter) }.to raise_error \
            expected_error_message
        end
      end
    end

    context 'when argument word_filter DOES NOT quack correctly to the right class methods' do
      before { allow(filter_class).to receive(:respond_to?).with(method_to_check).and_return(false) }

      context 'when word_filter class does not respond to #filter_match?' do
        let(:method_to_check) { :filter_match? }

        it 'raises an error' do
          expect { subject.validate_word_filter(word_filter: numeric_filter) }.to raise_error \
            expected_error_message
        end
      end
    end
  end
end
