RSpec.shared_examples 'an instantiated object' do
  it 'instantiates the object without error' do
    expect { subject }.to_not raise_error
  end
end

# This test should fail when calling any method that does not expect
# the dictionary being loaded, to already have been loaded.
# For example, DictionaryLoaded#load!.
RSpec.shared_examples 'a dictionary that is already loaded' do
  it 'raises an error' do
    expect { subject }.to raise_error LittleWeasel::Errors::DictionaryFileAlreadyLoadedError
  end
end

# This test should fail when calling any method that should return a
# add a dictionary to the DictionaryManager#dictionary_hash Hash, but
# returns a temporary dictionany instead. For example,
# DictionaryLoaded#load!. A temporary dictionary is one that is NOT
# added to the DictionaryManager#dictionary_hash Hash.
RSpec.shared_examples 'a permanently loaded dictionary' do
  it "loads a temporary dictionary" do
    expect(loaded_dictionary).to_not be_nil
  end
end

RSpec.shared_examples 'the dictionary was loaded' do
  context 'when the dictionary is NOT already loaded/cached' do
    let(:expected_dictionary_key_key) { create(:dictionary_key, language: :en, region: :us).key }
    let(:expected_results) do
      ['apple',
       'better',
       'cat',
       'dog',
       'everyone',
       'fat',
       'game',
       'help',
       'italic',
       'jasmine',
       'kelp',
       'love',
       'man',
       'nope',
       'octopus',
       'popeye',
       'queue',
       'ruby',
       'stop',
       'top',
       'ultimate',
       'very',
       'was',
       'xylophone',
       'yes',
       'zebra']
    end

    it 'returns an Array of dictionary words loaded from the file' do
      # This test won't pass if we're not testing against an assumed
      # dictionary file.
      expect(dictionary_key.key).to eq expected_dictionary_key_key
      expect(subject.execute).to eq expected_results
    end
  end
end

RSpec.shared_examples '#hash_key returns the expected key' do
  subject { create(sym_for(described_class), file: dictionary_file_path, tag: tag) }

  let(:file_name) { locale }
  let(:dictionary_file_path) { dictionary_path_for file_name: file_name }
  let(:tag) { 'test' }

  before do
    allow(subject).to receive(:locale).and_return locale
  end

  it 'returns the expected Hash key' do
    expect(subject.hash_key).to eq hash_key
  end
end
