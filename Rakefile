# frozen_string_literal: false

require 'active_support/core_ext/object/try.rb'
require 'active_support/inflector'
require 'benchmark/ips'
require 'bundler/gem_tasks'
require 'pry'
require 'rubocop/rake_task'

require_relative 'lib/LittleWeasel'
require_relative 'spec/support/file_helpers'
require_relative 'spec/support/general_helpers'

DictionaryResultsHelpers = Support::GeneralHelpers::DictionaryResultsHelpers

def file_from(dictionary_key)
  Support::FileHelpers.dictionary_path_for(file_name: dictionary_key.key)
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

#
# Tasks related to the #word_results API

namespace 'word_results' do
  desc 'Creates a dictionary from a file on disk - perform basic word search results operations'
  task :basic do
    LittleWeasel.configure do |config|
      # TODO: Configure as needed here.
    end

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
    DictionaryResultsHelpers.print_word_results word, word_results, "found (#{word} is in the dictionary)"

    # Get results for a word we know DOES NOT exist.
    word = 'dapple'
    word_results = en_us_names_dictionary.word_results word
    DictionaryResultsHelpers.print_word_results word, word_results, "not found (#{word} is not in the dictionary)"
  rescue StandardError => e
    task 'word_results:basic' do
      puts "LittleWeasel task word_results:basic not loaded: #{e.message}"
      exit 1
    end
  end

  desc 'Creates a dictionary from memory - perform basic word search results operations'
  task :from_memory do
    LittleWeasel.configure do |config|
      # TODO: Configure as needed here.
    end

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
    DictionaryResultsHelpers.print_word_results word, word_results, "found (#{word} is in the dictionary)"

    # Get results for a name we know DOES NOT exist.
    word = 'Henry'
    word_results = en_us_names_dictionary.word_results word
    DictionaryResultsHelpers.print_word_results word, word_results, "not found (#{word} is not in the dictionary)"
  rescue StandardError => e
    task 'word_results:from_memory' do
      puts "LittleWeasel task word_results:from_memory not loaded: #{e.message}"
      exit 1
    end
  end

  desc 'Creates a dictionary from memory - perform advanced word search results operations using word filters and preprocessors'
  task :advanced do
    LittleWeasel.configure do |config|
      # TODO: Configure as needed here.
    end

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
    word_preprocessors = [LittleWeasel::Preprocessors::EnUs::CapitalizePreprocessor.new]

    # Create a dictionary of names from memory.
    en_us_names_dictionary = dictionary_manager.create_dictionary_from_memory(
      dictionary_key: en_us_names_key,
      dictionary_words: %w(Abel Bartholomew Cain Deborah Elijah),
      word_filters: word_filters,
      word_preprocessors: word_preprocessors)

    puts '# Turning off our word filters and word preprocessors to start...'
    puts

    en_us_names_dictionary.filters_on = false
    en_us_names_dictionary.preprocessors_on = false

    # Get results for a name we know DOES NOT exist.
    word = 'Henry'
    word_results = en_us_names_dictionary.word_results word
    DictionaryResultsHelpers.print_word_results word, word_results, "not found, #success? == false, word_valid? == false (#{word} is not in the dictionary)"

    puts '# Turning word filters on...'
    puts

    en_us_names_dictionary.filters_on = true

    # Get results for Henry again - it should be found due to the filter.
    word = 'Henry'
    word_results = en_us_names_dictionary.word_results word
    DictionaryResultsHelpers.print_word_results word, word_results, '#success? == true due to the HenryFilter'

    # Get results for a name we know DOES NOT exist.
    word = 'henry'
    word_results = en_us_names_dictionary.word_results word
    DictionaryResultsHelpers.print_word_results word, word_results, "not found, #success? == false (#{word} is not in the dictionary and henry is lower case, no filter match)"

    puts '# Turning preprocessors on so that henry is converted to Henry '
    puts "# and consequently, the filter will match..."
    puts

    en_us_names_dictionary.preprocessors_on = true

    word = 'henry'
    word_results = en_us_names_dictionary.word_results word
    DictionaryResultsHelpers.print_word_results word, word_results, "#success? == true, #filter_match? == true (#{word} is not in the dictionary but the word preprocessor and word filter work together to get a filter match and consider the name valid)"
  rescue StandardError => e
    task 'word_results:advanced' do
      puts "LittleWeasel task word_results:advanced not loaded: #{e.message}"
      exit 1
    end
  end

  desc 'Creates a dictionary from memory - perform advanced word search results operations using word filters and preprocessors'
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
      DictionaryResultsHelpers.print_word_results word, word_results
    end
  rescue StandardError => e
    task 'word_results:word_filters' do
      puts "LittleWeasel task word_results:word_filters not loaded: #{e.message}"
      exit 1
    end
  end
end

#
# Tasks related to the #block_results API

namespace 'block_results' do
  desc 'Perform basic #block_results API operations'
  task :basic do
    LittleWeasel.configure do |config|
      # TODO: Configure as needed here.
    end

    # Create a Dictionary Manager.
    dictionary_manager = LittleWeasel::DictionaryManager.new

    # Create our unique key for the dictionary.
    en_us_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us, tag: :big)

    # Create a dictionary from a file on disk. The below assumes the
    # dictionary file name matches the dictionary key (e.g. en-US-big).
    en_us_dictionary = dictionary_manager.create_dictionary_from_file(
      dictionary_key: en_us_key, file: file_from(en_us_key))

    word_block = "This is a word-block of 8 words and 2 numbers."

    # Add a word filter so that numbers are considered valid.
    en_us_dictionary.add_filters word_filters: [
      LittleWeasel::Filters::EnUs::NumericFilter.new
    ]

    block_results = en_us_dictionary.block_results word_block

    # Returns a LittleWeasel::BlockResults object.
    DictionaryResultsHelpers.print_block_results word_block, block_results
  rescue StandardError => e
    task 'block_results:basic' do
      puts "LittleWeasel task block_results:basic not loaded: #{e.message}"
      exit 1
    end
  end
end

namespace :bm do
  desc 'Performs benchmarking on Hash lookups performance.'
  task :hash do
    STRING_LOCALE = { 'en-US' => 'en-us' }
    SYMBOL_LOCALE = { enUS: 'en-US' }

    puts "Benchmark Hash lookups using different Hash key data types."
    Benchmark.ips do |x|
      string_variable = 'en-US'
      x.report('hard-coded string') { STRING_LOCALE['en-US'] }
      x.report('hard-coded frozen string') { STRING_LOCALE['en-US'.freeze] }
      x.report('string variable') { STRING_LOCALE[string_variable] }
      x.report('symbol') { SYMBOL_LOCALE[:enUS] }
    end
  rescue StandardError => e
    task 'hash' do
      puts "LittleWeasel task bm:hash not loaded: #{e.message}"
      exit 1
    end
  end

  desc 'Performs benchmarking on the DictionaryKey class.'
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


desc 'Run LittleWeasel benchmark tests.'
task benchmarking: %w[bm:hash bm:dictionary_key]

RuboCop::RakeTask.new
task default: %i[spec rubocop]
