RSpec.shared_context 'dictionary cache' do #, shared_context: :metadata do
  def dictionary_cache_for(dictionary_key:, dictionary_reference: true, load: false)
    dictionary_cache_from(dictionary_keys: [{ dictionary_key: dictionary_key, dictionary_reference: dictionary_reference, load: load }])
  end

  # This method simple returns a snapshot of what the dictionary cache would
  # look like if the given dictionary_key(s) were added as a dictionary reference.
  # This method expects an Array of Hashes having the following format; if
  # load is omitted, 'load: false' is the default:
  #
  # [
  #  {
  #    dictionary_key: <dictionary_key>
  #    dictionary_reference: true | false | <file name minus extension>>,
  #    [, load: true | false]
  #  }
  # ]
  def dictionary_cache_from(dictionary_keys:)
    raise ArgumentError, 'Argument dictionary_keys is not an Array' unless dictionary_keys.is_a? Array

    dictionary_cache = {}

    dictionary_keys.each do |hash|
      raise ArgumentError, "Expected required Hash key :dictionary_key but it was not found" unless hash.key? :dictionary_key

      create(:dictionary_cache_service,
        dictionary_cache: dictionary_cache,
        dictionary_key: hash[:dictionary_key],
        dictionary_reference: hash[:dictionary_reference],
        load: hash.fetch(:load, false))
    end

    dictionary_cache
  end
end

RSpec.shared_context 'dictionary keys' do #, shared_context: :metadata do
  def dictionary_key_for(language:, region: nil, tag: nil)
   create(:dictionary_key, language: language, region: region, tag: tag)
  end
end

RSpec.shared_context 'mock word filters' do #, shared_context: :metadata do

  unless Object.const_defined?('WordFilter01')
    class WordFilter01 < LittleWeasel::Filters::WordFilter
      class << self
        def filter_match?(word)
          true
        end
      end
    end
  end

  unless Object.const_defined?('WordFilter02')
    class WordFilter02 < LittleWeasel::Filters::WordFilter
      class << self
        def filter_match?(word)
          true
        end
      end
    end
  end

  unless Object.const_defined?('DollarSignFilter')
    class DollarSignFilter < LittleWeasel::Filters::WordFilter
      class << self
        def filter_match?(word)
          word == '$'
        end
      end
    end
  end
end

RSpec.shared_context 'mock word preprocessors' do #, shared_context: :metadata do
  class UpcaseWordPreprocessor < LittleWeasel::Preprocessors::WordPreprocessor
    class << self
      def preprocess(word)
        [true, word.upcase];
      end
    end
  end

  class DowncaseWordPreprocessor < LittleWeasel::Preprocessors::WordPreprocessor
    class << self
      def preprocess(word)
        [true, word.downcase];
      end
    end
  end
end

RSpec.configure do |config|
  config.include_context 'dictionary cache', include_shared: true
  config.include_context 'dictionary keys', include_shared: true
  config.include_context 'mock word filters', include_shared: true
  config.include_context 'mock word preprocessors', include_shared: true
end
