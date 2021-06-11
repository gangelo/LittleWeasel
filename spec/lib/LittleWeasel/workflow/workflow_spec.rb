# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Workflow tests' do
  include_context 'dictionary cache'
  include_context 'dictionary keys'

  subject { LittleWeasel::DictionaryManager.new }

  # This loads the BIG en-US-big dictionary
  let(:en_us_dictionary_key) { dictionary_key_for(language: :en, region: :us, tag: :big) }
  let(:en_gb_dictionary_key) { dictionary_key_for(language: :en, region: :gb) }
  let(:es_es_dictionary_key) { dictionary_key_for(language: :es, region: :es) }

  let(:dictionary_key) { en_us_dictionary_key }
  let(:key) { dictionary_key.key }
  let(:file) { "#{ dictionary_path_for(file_name: key) }" }
  let(:dictionary_words) { dictionary_words_for(dictionary_file_path: file) }
end
