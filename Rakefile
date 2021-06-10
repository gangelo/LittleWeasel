# frozen_string_literal: true

require 'active_support/core_ext/object/try.rb'
require 'active_support/inflector'
require 'benchmark/ips'
require 'bundler/gem_tasks'
require 'pry'

require_relative 'lib/LittleWeasel'
require_relative 'spec/support/file_helpers'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => e
  task 'spec' do
    puts "RSpec not loaded - make sure it's installed and you're using bundle exec"
    exit 1
  end
end

task :workflow do
  require 'json'
  LittleWeasel.configure do |config|
    # TODO: Configure as needed here.
  end
  dictionary_manager = LittleWeasel::DictionaryManager.new

  dictionary_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us)
  file = Support::FileHelpers.dictionary_path_for file_name: dictionary_key.key
  dictionary_manager.add_dictionary_reference(dictionary_key: dictionary_key, file: file)
  dictionary = dictionary_manager.load_dictionary(dictionary_key: dictionary_key)
  IO.foreach("#{file}") do |word|
    word.strip!
    puts "word_valid?('#{word}'') #=> #{dictionary.word_valid?(word)}"
  end
rescue StandardError => e
  task 'workflow' do
    puts "LittleWeasel task workflow not loaded: #{e.message}"
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
