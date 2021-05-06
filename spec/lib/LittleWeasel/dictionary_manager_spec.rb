# frozen_string_literal: truef

require 'spec_helper'

RSpec.describe LittleWeasel::DictionaryManager do
  subject { create(sym_for(described_class)) }

  let(:language) { :en }
  let(:region) { :us }
  let(:dictionary_file_path) { dictionary_path_for(language: language, region: region) }
  let(:all_dictionaries_array) { [:default, [:en, [:default, :us, :gb]], [:es, [:default, :es]]] }
  let(:load_dictionaries) do
    # Language dictionary, :en
    subject << create(:language_dictionary, language: :en, file: language_dictionary_path(language: :en))

    # Region dictionaries, en-US, en-GB
    subject << create(:region_dictionary, language: :en, region: :us, file: region_dictionary_path(language: :en, region: :us))
    subject << create(:region_dictionary, language: :en, region: :gb, file: region_dictionary_path(language: :en, region: :gb))

    # Language dictionary, :es
    subject << create(:language_dictionary, language: :es, file: language_dictionary_path(language: :es))

    # Region dictionary, es-ES
    subject << create(:region_dictionary, language: :es, region: :es, file: region_dictionary_path(language: :es, region: :es))
  end

  describe '#instance' do
    it 'does not raise an error' do
      expect { subject.instance }.not_to raise_error
    end
  end

  context '#instance' do
    subject { create(sym_for(described_class)).instance }

    before(:each) do
      subject.reset
    end

    describe '#<<' do
      context 'with valid arguments' do
        context 'with one dictionary' do
          let(:dictionary) { create(:region_dictionary, language: :en, region: :us, file: region_dictionary_path(language: :en, region: :us)) }

          it 'adds the dictionary' do
            subject << dictionary

            expect(subject.dictionary_count).to eq 1
          end
        end

        context 'with mixed dictionary types' do
          include_context 'dictionaries_shared'
          before do
            allow(File).to receive(:exist?).and_return true
            load_dictionaries
          end

          it 'adds the dictionaries' do
            expect(subject.to_hash).to eq all_dictionaries_hash
          end
        end
      end

      context 'with invalid arguments' do
        context 'when nil' do
          it 'returns nil' do
            expect(subject << nil).to be_nil
          end
        end

        context 'when the wrong type' do
          it 'returns nil' do
            expect(subject << %i[not good]).to be_nil
          end
        end
      end
    end

    describe '#dictionary_count' do
      context 'with mixed dictionaries' do
        before do
          allow(File).to receive(:exist?).and_return true
          load_dictionaries
        end

        let(:dictionary) { create(:language_dictionary, file: language_dictionary_path(language: :xx)) }

        it 'returns the right dictionary count' do
          expect(subject.dictionary_count).to eq 5
        end
      end
    end

    describe '#to_hash' do
      before do
        allow(File).to receive(:exist?).and_return true
        load_dictionaries
      end

      it 'returns the right hash' do
        dictionaries_hash = subject.to_hash
        expect(subject.dictionary_count).to eq 5
        expect(dictionaries_hash[hash_key_for(:en)]).to match(/en\.txt/)
        expect(dictionaries_hash[hash_key_for(:es)]).to match(/es\.txt/)
        expect(dictionaries_hash[hash_key_for(:en, :us)]).to match(/en-US\.txt/)
        expect(dictionaries_hash[hash_key_for(:en, :gb)]).to match(/en-GB\.txt/)
        expect(dictionaries_hash[hash_key_for(:es, :es)]).to match(/es-ES\.txt/)
      end
    end

    describe '#dictionary_path' do
      before do
        allow(File).to receive(:exist?).and_return true
        load_dictionaries
      end

      context 'with a valid language and valid region' do
        let(:hash_key) { hash_key_for(:en, :us) }

        it 'returns the region dictionary file' do
          expect(subject.dictionary_path(hash_key)).to match(/en-US\.txt/)
        end
      end

      context 'with a valid language and invalid region' do
        let(:hash_key) { hash_key_for(:en, :invalid) }

        it 'falls back to the default language dictionary file (if it exists)' do
          expect(subject.dictionary_path(hash_key)).to match(/en\.txt/)
        end
      end
    end

    describe '#reset' do
      before do
        allow(File).to receive(:exist?).and_return true
        load_dictionaries
      end

      it 'resets all the dictionaries to 0' do
        expect { subject.reset }.to change { subject.dictionary_count }.from(5).to(0)
      end
    end
  end
end
