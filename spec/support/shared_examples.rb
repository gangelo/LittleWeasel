RSpec.shared_examples 'the dictionary_key is invalid' do
  context 'when the dictionary_key is nil' do
    let(:dictionary_key) {}

    it 'raises an error' do
      expect { subject }.to raise_error "Argument dictionary_key is not a valid DictionaryKey object: #{dictionary_key.class}"
    end
  end

  context 'when the dictionary_key is the wrong type' do
    let(:dictionary_key) { :bad_dictionary_key }

    it 'raises an error' do
      expect { subject }.to raise_error "Argument dictionary_key is not a valid DictionaryKey object: #{dictionary_key.class}"
    end
  end
end

RSpec.shared_examples 'the dictionary_cache is invalid' do
  context 'when the dictionary_cache is nil' do
    let(:dictionary_cache) {}

    it 'raises an error' do
      expect { subject }.to raise_error "Argument dictionary_cache is not a valid Hash object: #{dictionary_cache.class}"
    end
  end

  context 'when the dictionary_cache is the wrong type' do
    let(:dictionary_cache) { :bad_dictionary_cache }

    it 'raises an error' do
      expect { subject }.to raise_error "Argument dictionary_cache is not a valid Hash object: #{dictionary_cache.class}"
    end
  end
end

RSpec.shared_examples 'the dictionary_metadata is invalid' do
  context 'when the dictionary_metadata is nil' do
    let(:dictionary_metadata) {}

    it 'raises an error' do
      expect { subject }.to raise_error "Argument dictionary_metadata is not a valid Hash object: #{dictionary_metadata.class}"
    end
  end

  context 'when the dictionary_metadata is the wrong type' do
    let(:dictionary_metadata) { :bad_dictionary_metadata }

    it 'raises an error' do
      expect { subject }.to raise_error "Argument dictionary_metadata is not a valid Hash object: #{dictionary_metadata.class}"
    end
  end
end

RSpec.shared_examples 'the filter matches and #filter_on? is true' do
  it 'returns true' do
    expect(subject.filter_match? word).to eq true
  end
end

RSpec.shared_examples 'the filter DOES NOT match and #filter_on? is true' do
  it 'returns false' do
    expect(subject.filter_match? word).to eq false
  end
end

RSpec.shared_examples 'the filter matches and #filter_on? is false' do
  it 'returns false' do
    expect(subject.filter_match? word).to eq false
  end
end

RSpec.shared_examples 'the filter DOES NOT match and #filter_on? is false' do
  it 'returns false' do
    expect(subject.filter_match? word).to eq false
  end
end
