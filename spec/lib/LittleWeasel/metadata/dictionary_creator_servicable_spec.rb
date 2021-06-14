# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LittleWeasel::Modules::DictionaryCreatorServicable, type: :module do
  include_context 'dictionary keys'

  DictionaryCreatorServicable = described_class

  class SubjectMock
    include DictionaryCreatorServicable
    include LittleWeasel::Filters::WordFilterable
    include LittleWeasel::Modules::DictionaryKeyable
    include LittleWeasel::Modules::DictionaryMetadataServicable

    def initialize(dictionary_key:, dictionary_cache:, dictionary_metadata:, file:, word_filters:)
      self.dictionary_key = dictionary_key
      self.dictionary_cache = dictionary_cache
      self.dictionary_metadata = dictionary_metadata
      self.file = file
      self.word_filters = word_filters
    end

    def execute
      dictionary_creator_service.execute
    end
  end

  subject { SubjectMock.new(dictionary_key: dictionary_key, dictionary_cache: dictionary_cache, dictionary_metadata: dictionary_metadata, file: file, word_filters: word_filters) }

  let(:en_us_dictionary_key) { dictionary_key_for(language: :en, region: :us) }
  let(:dictionary_key) { en_us_dictionary_key }
  let(:key) { dictionary_key.key }
  let(:file) { "#{ dictionary_path_for(file_name: key) }" }
  let(:dictionary_cache) { {} }
  let(:dictionary_metadata) { {} }
  let(:word_filters) {}

  it 'instantiates' do
    expect { subject.execute }.to_not raise_error
  end
end
