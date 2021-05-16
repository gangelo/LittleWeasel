# frozen_string_literal: true

require 'active_support/core_ext/object/try.rb'
require 'benchmark/ips'
require 'bundler/gem_tasks'
require 'pry'

require_relative 'lib/LittleWeasel'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => e
  task 'spec' do
    puts "RSpec not loaded - make sure it's installed and you're using bundle exec"
    exit 1
  end
end

task :lw do
  require 'json'
  LittleWeasel.configure do |config|
    # TODO: Configure as needed here.
  end
  path = 'spec/support/files'
  dm = LittleWeasel::DictionaryManager.instance

  puts 'TODO: Loading dictionaries...'
  # puts JSON.pretty_generate(dm.to_hash)
rescue StandardError => e
  task 'lw' do
    puts e.backtrace
    puts "LittleWeasel task lw not loaded: #{e.message}"
    exit 1
  end
end

task :workflow do
  require 'json'
  LittleWeasel.configure do |config|
    # TODO: Configure as needed here.
  end
  path = 'spec/support/files'
  dm = LittleWeasel::DictionaryManager.instance
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
      x.report('DictionaryKey') { DictionaryKey.key(language: :en, region: :us, tag: :tag) }
    end
  rescue StandardError => e
    task 'locale' do
      puts "LittleWeasel task bm:dictionary_key not loaded: #{e.message}"
      exit 1
    end
  end
end

task default: :spec
