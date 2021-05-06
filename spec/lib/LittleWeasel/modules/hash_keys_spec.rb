# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::HashKeys, type: :module do
  let(:language) { :en }
  let(:region) { :us }
  let(:tag) {}
  let(:hash_key) { subject.join_key language: language, region: region, tag: tag }
  let(:expected_hash) { { language: language&.to_s&.downcase, region: region&.to_s&.upcase, tag: tag&.to_s } }

  # .join_key
  describe '.join_key' do
    context 'when joining a language' do
      let(:expected_hash_key) { "#{language.downcase}--" }

      it 'returns the expected key' do
        expect(subject.join_key language: language).to eq expected_hash_key
      end
    end

    context 'when joining a language and region' do
      let(:expected_hash_key) { "#{language.downcase}-#{region.upcase}-" }

      it 'returns the expected key' do
        expect(subject.join_key language: language, region: region).to eq expected_hash_key
      end
    end

    context 'when joining a language, region and tag' do
      let(:tag) { :tagger }
      let(:expected_hash_key) { "#{language.downcase}-#{region.upcase}-#{tag}" }

      it 'returns the expected key' do
        expect(subject.join_key language: language, region: region, tag: tag).to eq expected_hash_key
      end
    end

    context 'when joining a language and tag' do
      let(:tag) { :tagger }
      let(:expected_hash_key) { "#{language.downcase}--#{tag}" }

      it 'returns the expected key' do
        expect(subject.join_key language: language, region: nil, tag: tag).to eq expected_hash_key
      end
    end

    context 'when joining tag' do
      let(:language) {}
      let(:region) {}
      let(:tag) { :tagger }
      let(:expected_hash_key) { "--#{tag}" }

      it 'raises an error' do
        expect { subject.join_key(language: language, region: region, tag: tag) }.to \
          raise_error LittleWeasel::Errors::LanguageRequiredError
      end
    end
  end

  # .split_key: tested through .split_key_to_hash

  # .split_key_to_hash
  describe '.split_key_to_hash' do
    context 'when splitting a Region Dictionary Hash key' do
      it 'returns the expected Hash' do
        expect(subject.split_key_to_hash hash_key).to eq(expected_hash)
      end
    end

    context 'when splitting a Language Dictionary Hash key' do
      let(:region) {}

      it 'returns the expected Hash' do
        expect(subject.split_key_to_hash hash_key).to eq(expected_hash)
      end
    end

    context 'with a tag' do
      let(:tag) { :tagger }

      context 'when splitting a Region Dictionary Hash key' do
        it 'returns the expected Hash' do
          expect(subject.split_key_to_hash hash_key).to eq(expected_hash)
        end
      end

      context 'when splitting a Language Dictionary Hash key' do
        let(:region) {}

        it 'returns the expected Hash' do
          expect(subject.split_key_to_hash hash_key).to eq(expected_hash)
        end
      end
    end
  end

  # .language_key?
  describe '.language_key?' do
    context 'when a Language Dictionary key' do
      let(:language) { :en }
      let(:region) {}
      let(:tag) {}

      it 'returns true' do
        expect(subject.language_key? hash_key).to eq true
      end
    end

    context 'when a tagged Language Dictionary key' do
      let(:language) { :en }
      let(:region) {}
      let(:tag) { :tagger }

      it 'returns true' do
        expect(subject.language_key? hash_key).to eq true
      end
    end

    context 'when a Region Dictionary key' do
      let(:language) { :en }
      let(:region) { :us }
      let(:tag) {}

      it 'returns false' do
        expect(subject.language_key? hash_key).to eq false
      end
    end
  end

  # .region_key?
  describe '.region_key?' do
    context 'when a Language Dictionary key' do
      let(:language) { :en }
      let(:region) {}
      let(:tag) {}

      it 'returns false' do
        expect(subject.region_key? hash_key).to eq false
      end
    end

    context 'when a Region Dictionary key' do
      let(:language) { :en }
      let(:region) { :us }
      let(:tag) {}

      it 'returns true' do
        expect(subject.region_key? hash_key).to eq true
      end
    end

    context 'when a tagged Region Dictionary key' do
      let(:language) { :en }
      let(:region) { :us }
      let(:tag) { :tagger }

      it 'returns true' do
        expect(subject.region_key? hash_key).to eq true
      end
    end
  end

  # .tagged_key?
  describe '.tagged_key?' do
    context 'when a Language Dictionary key' do
      let(:language) { :en }
      let(:region) {}
      let(:tag) {}

      it 'returns false' do
        expect(subject.tagged_key? hash_key).to eq false
      end
    end

    context 'when a Region Dictionary key' do
      let(:language) { :en }
      let(:region) { :us }
      let(:tag) {}

      it 'returns false' do
        expect(subject.tagged_key? hash_key).to eq false
      end
    end

    context 'when a tagged Language Dictionary key' do
      let(:language) { :en }
      let(:region) {}
      let(:tag) { :tagger }

      it 'returns true' do
        expect(subject.tagged_key? hash_key).to eq true
      end
    end

    context 'when a tagged Region Dictionary key' do
      let(:language) { :en }
      let(:region) { :us }
      let(:tag) { :tagger }

      it 'returns true' do
        expect(subject.tagged_key? hash_key).to eq true
      end
    end
  end

  # .split_to_bool
  describe '.split_to_bool' do
    context 'when a Language Dictionary key' do
      let(:language) { :en }
      let(:region) {}
      let(:tag) {}

      it 'returns the expected Array with the expected values' do
        expect(subject.split_to_bool hash_key).to eq [true, false, false]
      end
    end

    context 'when a Region Dictionary key' do
      let(:language) { :en }
      let(:region) { :us }
      let(:tag) {}

      it 'returns the expected Array with the expected values' do
        expect(subject.split_to_bool hash_key).to eq [true, true, false]
      end
    end

    context 'when a tagged Language Dictionary key' do
      let(:language) { :en }
      let(:region) {}
      let(:tag) { :tagger }

      it 'returns the expected Array with the expected values' do
        expect(subject.split_to_bool hash_key).to eq [true, false, true]
      end
    end

    context 'when a tagged Region Dictionary key' do
      let(:language) { :en }
      let(:region) { :us }
      let(:tag) { :tagger }

      it 'returns the expected Array with the expected values' do
        expect(subject.split_to_bool hash_key).to eq [true, true, true]
      end
    end
  end
end
