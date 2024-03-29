# frozen_string_literal: true

RSpec.shared_context 'dictionary cache' do
  def dictionary_cache_for(dictionary_key:, dictionary_file_source: true, load: false)
    dictionary_cache_from(dictionary_keys: [{ dictionary_key: dictionary_key, dictionary_file_source: dictionary_file_source, load: load }])
  end

  # This method simple returns a snapshot of what the dictionary cache would
  # look like if the given dictionary_key(s) were added as a dictionary reference.
  # This method expects an Array of Hashes having the following format; if
  # load is omitted, 'load: false' is the default:
  #
  # [
  #  {
  #    dictionary_key: <dictionary_key>
  #    dictionary_file_source: nil | true | false | <file name minus extension>,
  #    dictionary_memory_source: nil | true | false |,
  #    [, load: true | false]
  #  }
  # ]
  def dictionary_cache_from(dictionary_keys:)
    raise ArgumentError, 'Argument dictionary_keys is not an Array' unless dictionary_keys.is_a? Array

    dictionary_cache = {}

    dictionary_keys.each do |hash|
      unless hash.key? :dictionary_key
        raise ArgumentError, 'Expected required Hash key :dictionary_key but it was not found'
      end

      create(:dictionary_cache_service,
        dictionary_cache: dictionary_cache,
        dictionary_key: hash[:dictionary_key],
        dictionary_file_source: hash[:dictionary_file_source],
        dictionary_memory_source: hash[:dictionary_memory_source],
        load: hash.fetch(:load, false))
    end

    dictionary_cache
  end
end

RSpec.shared_context 'dictionary keys' do
  def dictionary_key_for(language:, region: nil, tag: nil)
    create(:dictionary_key, language: language, region: region, tag: tag)
  end
end

RSpec.shared_context 'mock word filters' do
  unless Object.const_defined?(:WordFilter01)
    class WordFilter01 < LittleWeasel::Filters::WordFilter
      class << self
        def filter_match?(_word)
          true
        end
      end
    end
  end

  unless Object.const_defined?(:WordFilter02)
    class WordFilter02 < LittleWeasel::Filters::WordFilter
      class << self
        def filter_match?(_word)
          true
        end
      end
    end
  end

  unless Object.const_defined?(:DollarSignFilter)
    class DollarSignFilter < LittleWeasel::Filters::WordFilter
      class << self
        def filter_match?(word)
          word == '$'
        end
      end
    end
  end
end

RSpec.shared_context 'mock word preprocessors' do
  class UpcaseWordPreprocessor < LittleWeasel::Preprocessors::WordPreprocessor
    class << self
      def preprocess(word)
        [true, word.upcase]
      end
    end
  end

  class DowncaseWordPreprocessor < LittleWeasel::Preprocessors::WordPreprocessor
    class << self
      def preprocess(word)
        [true, word.downcase]
      end
    end
  end
end

RSpec.shared_context 'dictionary sourceable' do
  def memory_source
    LittleWeasel::Modules::DictionarySourceable.memory_source
  end
end

RSpec.configure do |config|
  config.include_context 'dictionary cache', include_shared: true
  config.include_context 'dictionary keys', include_shared: true
  config.include_context 'dictionary sourceable', include_shared: true
  config.include_context 'mock word filters', include_shared: true
  config.include_context 'mock word preprocessors', include_shared: true
end
