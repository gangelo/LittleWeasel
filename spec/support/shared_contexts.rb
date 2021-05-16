RSpec.shared_context 'dictionary cache keys', shared_context: :metadata do
  DICTIONARY_REFERENCES = LittleWeasel::Modules::DictionaryCacheKeys::DICTIONARY_REFERENCES
  DICTIONARY_FILE_KEY = LittleWeasel::Modules::DictionaryCacheKeys::DICTIONARY_FILE_KEY
  DICTIONARY_CACHE = LittleWeasel::Modules::DictionaryCacheKeys::DICTIONARY_CACHE
  DICTIONARY_METADATA = LittleWeasel::Modules::DictionaryCacheKeys::DICTIONARY_METADATA
  DICTIONARY_OBJECT = LittleWeasel::Modules::DictionaryCacheKeys::DICTIONARY_OBJECT
  DICTIONARY_CACHE_ROOT_KEYS = LittleWeasel::Modules::DictionaryCacheKeys::DICTIONARY_CACHE_ROOT_KEYS
end

RSpec.configure do |config|
  config.include_context 'dictionary cache keys', include_shared: true
end
