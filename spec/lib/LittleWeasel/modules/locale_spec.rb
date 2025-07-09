# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::Locale, type: :module do
  Locale = described_class

  subject do
    Class.new do
      include Locale

      attr_reader :language, :region

      def initialize(language, region)
        self.language = language
        self.region = region
      end

      private

      attr_writer :language, :region
    end.new(language, region)
  end

  let(:language) {}
  let(:region) {}

  # locale
  describe '#locale' do
    context 'with valid arguments' do
      context 'with valid language' do
        let(:language) { :en }

        it 'returns the expected locale (language only)' do
          expect(subject.locale).to eq 'en'
        end
      end

      context 'with valid language and region' do
        let(:language) { :en }
        let(:region) { :us }

        it 'returns the expected locale (language and region)' do
          expect(subject.locale).to eq 'en-US'
        end

        describe 'normalizes language and region to the proper case' do
          let(:language) { :EN }
          let(:region) { :us }

          it 'returns the expected locale with language lowercase and region uppercase' do
            expect(subject.locale).to eq 'en-US'
          end
        end
      end

      context 'with valid language and nil region' do
        let(:language) { :en }
        let(:region) {}

        it 'returns the expected locale (language only)' do
          expect(subject.locale).to eq 'en'
        end
      end

      context 'with valid language and blank region' do
        let(:language) { :en }
        let(:region) { '' }

        it 'returns the expected locale (language only)' do
          expect(subject.locale).to eq 'en'
        end
      end
    end

    context 'with invalid arguments' do
      context 'when argument language does not respond to #downcase' do
        let(:language) { 1 }

        it 'raises an error' do
          expect { subject.locale }.to raise_error(NoMethodError, /undefined method [`|']downcase'/)
        end
      end

      context 'when argument region does not respond to #upcase' do
        let(:language) { :en }
        let(:region) { 1 }

        it 'raises an error' do
          expect { subject.locale }.to raise_error(NoMethodError, /undefined method [`|']upcase'/)
        end
      end
    end
  end
end
