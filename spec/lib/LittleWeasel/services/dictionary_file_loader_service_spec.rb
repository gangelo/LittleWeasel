# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Services::DictionaryFileLoaderService do
  subject! { create(:dictionary_file_loader_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache) }

  include_context 'dictionary cache'

  before do
    LittleWeasel::Services::DictionaryCacheService.init dictionary_cache: dictionary_cache
  end

  let(:dictionary_key) { create(:dictionary_key, language: :en, region: :us) }
  let(:key) { dictionary_key.key }
  let(:dictionary_cache) { {} }

  # execute
  describe '#execute' do
    context 'when the dictionary is already loaded/cached' do
      before do
        create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_file_source: true, load: true)
      end

      it 'raises an error' do
        expect { subject.execute }.to raise_error "The dictionary associated with key '#{key}' already exists."
      end
    end

    context 'when the dictionary is NOT already loaded/cached' do
      before do
        create(:dictionary_cache_service, dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_file_source: true)
      end

      let(:expected_key) { create(:dictionary_key, language: :en, region: :us).key }
      let(:expected_results) do
        %w[apple
           better
           cat
           dog
           everyone
           fat
           game
           help
           italic
           jasmine
           kelp
           love
           man
           nope
           octopus
           popeye
           queue
           ruby
           stop
           top
           ultimate
           very
           was
           xylophone
           yes
           zebra]
      end

      it 'returns an Array of dictionary words loaded from the file' do
        expect(key).to eq expected_key
        expect(subject.execute).to eq expected_results
      end
    end
  end
end
