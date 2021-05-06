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
# temporary dictionary, but adds a dictionary to the
# DictionaryManager#dictionary_hash Hash instead. For example,
# DictionaryLoaded#load. A temporary dictionary is one that is NOT
# added to the DictionaryManager#dictionary_hash Hash.
RSpec.shared_examples 'a temprarily loaded dictionary' do
  it "loads a temporary dictionary" do
    expect(loaded_dictionary).to be_nil
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

# These tests should pass for dictionary files considered invalid (i.e.
# a dictionary that can NOTbe used by this Gem).
RSpec.shared_examples 'an invalid dictionary file' do
  context 'when it does not exist' do
    let(:dictionary_path) { region_dictionary_path language: :bad, region: :worse }

    it 'raises an error' do
      expect { subject }.to raise_error LittleWeasel::Errors::DictionaryFileNotFoundError
    end
  end

  context 'when it is empty' do
    let(:dictionary_path) { build_dictionary_path_for file_name: 'empty-dictionary' }

    it 'raises an error' do
      expect { subject }.to raise_error LittleWeasel::Errors::DictionaryFileEmptyError
    end
  end

  context 'when it is too large' do
    before do
      allow(LittleWeasel.configuration).to receive(:max_dictionary_file_bytes).and_return 1
    end

    let(:dictionary_path) { language_dictionary_path language: :en }

    it 'raises an error' do
      expect { subject }.to raise_error LittleWeasel::Errors::DictionaryFileTooLargeError
    end
  end
end

# TODO: Move any specs using this to the dictionaries_spec, since
# this is just duplicating coverage (e.g. dictionary_loader_spec.rb)?
# These tests should pass for dictionary files considered valid (i.e.
# a dictionary that can be used by this Gem).
RSpec.shared_examples 'a valid dictionary file' do
  before { subject }

  it 'loads the dictionary' do
    expect(subject).to_not be_nil
  end

  it 'the dictionary is searchable' do
    expect(subject['zebra']).to eq true
  end

  describe 'searching the dictionary' do
    context 'when the words exists' do
      it 'they are added to the dictionary Hash' do
        expect(subject.count).to be_zero
        expect(subject['a']).to eq true
        expect(subject['game']).to eq true
        expect(subject['man']).to eq true
        expect(subject['top']).to eq true
        expect(subject['zebra']).to eq true
        expect(subject).to eq({'a'=>true, 'game'=>true, 'man'=>true, 'top'=>true, 'zebra'=>true})
      end
    end

    context 'when the words do not exist' do
      context 'when the max_invalid_words_bytesize configuration setting threashold has NOT been met' do
        before do
          LittleWeasel.configure do |config|
            config.max_invalid_words_bytesize = 25_000
          end
        end

        it 'they are added to the dictionary Hash as words not found' do
          expect(subject.count).to be_zero
          expect(subject['a']).to eq true
          expect(subject['badword1']).to eq false
          expect(subject['badword2']).to eq false
          expect(subject['game']).to eq true
          expect(subject['man']).to eq true
          expect(subject['top']).to eq true
          expect(subject['zebra']).to eq true
          expect(subject).to eq({'a'=>true, 'badword1'=>false, 'badword2'=>false, 'game'=>true, 'man'=>true, 'top'=>true, 'zebra'=>true})
        end
      end

      context 'when the max_invalid_words_bytesize configuration setting threashold has been exceeded' do
        before do
          LittleWeasel.configure do |config|
            config.max_invalid_words_bytesize = 0
          end
        end

        it 'they are not added to the dictionary Hash' do
          expect(subject.count).to be_zero
          expect(subject['a']).to eq true
          expect(subject['badword1']).to eq false
          expect(subject['badword2']).to eq false
          expect(subject['game']).to eq true
          expect(subject['man']).to eq true
          expect(subject['top']).to eq true
          expect(subject['zebra']).to eq true
          expect(subject).to eq({'a'=>true, 'game'=>true, 'man'=>true, 'top'=>true, 'zebra'=>true})
        end
      end
    end
  end
end

RSpec.shared_examples '#hash_key returns the expected key' do
  subject { create(sym_for(described_class), file: dictionary_file_path, tag: tag) }

  let(:file_name) { locale }
  let(:dictionary_file_path) { build_dictionary_path_for file_name: file_name }
  let(:tag) { 'test' }

  before do
    allow(subject).to receive(:locale).and_return locale
  end

  it 'returns the expected Hash key' do
    expect(subject.hash_key).to eq hash_key
  end
end
