# frozen_string_literal: true

require 'active_support/core_ext/object/try.rb'
require 'active_support/inflector'
require 'benchmark/ips'
require 'bundler/gem_tasks'
require 'pry'

require_relative 'lib/LittleWeasel'
require_relative 'spec/support/file_helpers'

def print_word_results(word, word_results, comments = nil)
  puts "word_results for '#{word}'..."
  puts "comments: #{comments}" unless comments.nil?
  puts "word_results #=>"
  puts "  #original_word: #{word_results.original_word}"
  puts "  #preprocessed_word: #{word_results.preprocessed_word}"
  puts "  #success?: #{word_results.success?}"
  puts "  #word_valid?: #{word_results.word_valid?}"
  puts "  #word_cached?: #{word_results.word_cached?}"
  puts "  #preprocessed_word?: #{word_results.preprocessed_word?}"
  puts "  #preprocessed_word_or_original_word: #{word_results.preprocessed_word_or_original_word}"
  puts "  #filter_match?: #{word_results.filter_match?}"
  puts "  #filters_matched: #{word_results.filters_matched}"
  puts "  #preprocessed_words:"
  word_results.preprocessed_words&.preprocessed_words.each_with_index do |preprocessed_word, index|
    puts "    preprocessed_word #{index} #=>"
    puts "      #preprocessor: :#{preprocessed_word.preprocessor}"
    puts "      #preprocessor_order: #{preprocessed_word.preprocessor_order}"
  end
  puts
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => e
  task 'spec' do
    puts "RSpec not loaded - make sure it's installed and you're using bundle exec"
    exit 1
  end
end

# Creates a dictionary from a file on disk
task :from_file do
  LittleWeasel.configure { |config| }

  # Create a Dictionary Manager.
  dictionary_manager = LittleWeasel::DictionaryManager.new

  # Create our unique key for the dictionary.
  en_us_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us)

  file = Support::FileHelpers.dictionary_path_for file_name: en_us_key.key

  # Create a dictionary of names from memory.
  en_us_names_dictionary = dictionary_manager.create_dictionary_from_file(
    dictionary_key: en_us_key,
    file: file)

  # Get some word results...

  # Get results for a word we know exists.
  word = 'apple'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, "found (#{word} is in the dictionary)"

  # Get results for a word we know DOES NOT exist.
  word = 'dapple'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, "not found (#{word} is not in the dictionary)"
rescue StandardError => e
  task 'from_file' do
    puts "LittleWeasel task from_file not loaded: #{e.message}"
    exit 1
  end
end

# Creates a dictionary of names from memory
task :from_memory do
  LittleWeasel.configure { |config| }

  # Create a Dictionary Manager.
  dictionary_manager = LittleWeasel::DictionaryManager.new

  # Create our unique key for the dictionary.
  en_us_names_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us, tag: :names)

  # Create a dictionary of names from memory.
  en_us_names_dictionary = dictionary_manager.create_dictionary_from_memory(
    dictionary_key: en_us_names_key, dictionary_words: %w(Abel Bartholomew Cain Deborah Elijah))

  # Get some word results...

  # Get results for a name we know exists.
  word = 'Abel'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, "found (#{word} is in the dictionary)"

  # Get results for a name we know DOES NOT exist.
  word = 'Henry'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, "not found (#{word} is not in the dictionary)"
rescue StandardError => e
  task 'from_memory' do
    puts "LittleWeasel task from_memory not loaded: #{e.message}"
    exit 1
  end
end

# Shows application of word filters and word preprocessors.
task :advanced do
  LittleWeasel.configure { |config| }

  # Create a Dictionary Manager.
  dictionary_manager = LittleWeasel::DictionaryManager.new

  # Create our unique key for the dictionary.
  en_us_names_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us, tag: :names)

  # Create a Henry word filter.
  class HenryFilter < LittleWeasel::Filters::WordFilter
    class << self
      def filter_match?(word)
        word== 'Henry'
      end
    end
  end
  word_filters = [HenryFilter.new]

  # Add a word preprocessor.
  word_preprocessors = [LittleWeasel::Preprocessors::EnUs::CapitalizePreprocessor.new(preprocessor_on: false)]

  # Create a dictionary of names from memory.
  en_us_names_dictionary = dictionary_manager.create_dictionary_from_memory(
    dictionary_key: en_us_names_key,
    dictionary_words: %w(Abel Bartholomew Cain Deborah Elijah),
    word_filters: word_filters,
    word_preprocessors: word_preprocessors)

  # Turn off our word filters and word preprocessors to start
  en_us_names_dictionary.filters_on = false
  en_us_names_dictionary.preprocessors_on = false

  # Get results for a name we know DOES NOT exist.
  word = 'Henry'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, "not found (#{word} is not in the dictionary)"

  # Turn the filters on so we get a hit.
  en_us_names_dictionary.filters_on = true

  # Get results for Henry again - it should be found due to the filter.
  word = 'Henry'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, 'should be found due to the HenryFilter!'

  # Get results for a name we know DOES NOT exist.
  word = 'henry'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, "not found (#{word} is not in the dictionary and henry is lower case, no filter match)"

  # Turn our preprocessors on so that henry is converted to Henry
  # and consequently, the filter will match and we'll get a hit.
  en_us_names_dictionary.preprocessors_on = true

  word = 'henry'
  word_results = en_us_names_dictionary.word_results word
  print_word_results word, word_results, "found (#{word} is not in the dictionary but the word preprocessor and word filter work together to get a filter match and consider the name valid)"
rescue StandardError => e
  task 'from_memory' do
    puts "LittleWeasel task from_memory not loaded: #{e.message}"
    exit 1
  end
end

task :word_filters do
  LittleWeasel.configure do |config|
    # TODO: Configure as needed here.
  end
  dictionary_manager = LittleWeasel::DictionaryManager.new
  dictionary_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us)
  file = Support::FileHelpers.dictionary_path_for file_name: dictionary_key.key
  word_filters = [
    LittleWeasel::Filters::EnUs::NumericFilter.new,
    LittleWeasel::Filters::EnUs::CurrencyFilter.new,
    LittleWeasel::Filters::EnUs::SingleCharacterWordFilter.new
  ]
  word_preprocessors = nil
  dictionary_words = Support::FileHelpers.dictionary_words_for dictionary_file_path: file
  dictionary = dictionary_manager.create_dictionary_from_memory(dictionary_key: dictionary_key, dictionary_words: dictionary_words, word_filters: word_filters, word_preprocessors: word_preprocessors)
  dictionary_words << 'A'.dup
  dictionary_words << 'I'.dup
  dictionary_words << '1000'.dup
  dictionary_words << '1,000'.dup
  dictionary_words << '10,000.00'.dup
  dictionary_words << '+100.00'.dup
  dictionary_words << '-200,000.00'.dup
  dictionary_words << '$100,000'.dup
  dictionary_words << '+$100,000,000.10'.dup
  dictionary_words << '-$999,000,000.10'.dup
  dictionary_words.each do |word|
    word.strip!
    word_results = dictionary.word_results word
    print_word_results word, word_results
  end
rescue StandardError => e
  task 'workflow' do
    puts "LittleWeasel task word_filters not loaded: #{e.message}"
    exit 1
  end
end

namespace :bm do
  task :hash do
    STRING_LOCALE = { 'en-US' => 'en-us' }
    SYMBOL_LOCALE = { 'en-US' => :enUS }

    puts 'String variable vs. normal String.'
    Benchmark.ips do |x|
      string_variable = 'string_variable'
      x.report('string variable') { STRING_LOCALE[string_variable] }
      x.report('normal') { STRING_LOCALE['en-US'] }
    end

    puts 'String#freeze vs. normal String.'
    Benchmark.ips do |x|
      x.report('freeze') { STRING_LOCALE['en-US'.freeze] }
      x.report('normal') { STRING_LOCALE['en-US'] }
    end

    puts 'String vs Symbol'
    Benchmark.ips do |x|
      x.report('string') { STRING_LOCALE['en-US'] }
      x.report('symbol') { SYMBOL_LOCALE[:enUS] }
    end

    puts 'String#freeze vs. Symbol'
    Benchmark.ips do |x|
      x.report('string') { STRING_LOCALE['en-US'.freeze] }
      x.report('symbol') { SYMBOL_LOCALE[:enUS] }
    end
  rescue StandardError => e
    task 'hash' do
      puts "LittleWeasel task bm:hash not loaded: #{e.message}"
      exit 1
    end
  end

  task :dictionary_key do
    puts 'DictionaryKey test'
    Benchmark.ips do |x|
      x.report('DictionaryKey') do
        DictionaryKey.key(language: :en, region: :us, tag: :tag)
      end
    end
  rescue StandardError => e
    task 'locale' do
      puts "LittleWeasel task bm:dictionary_key not loaded: #{e.message}"
      exit 1
    end
  end
end

task default: :spec
