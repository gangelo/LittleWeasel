# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'active_support/core_ext/object/try.rb'
require 'pry'

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
  require_relative 'lib/LittleWeasel'
  LittleWeasel.configure do |config|
    # TODO: Configure as needed here.
  end
  path = 'spec/support/files'
  dm = LittleWeasel::DictionaryManager.instance

  puts 'Loading dictionaries...'
  dm << LittleWeasel::LanguageDictionary.new(language: :en, file: "#{path}/en-language.txt")
  dm << LittleWeasel::RegionDictionary.new(language: :en, region: :us, file: "#{path}/en-US-region.txt")
  dm << LittleWeasel::LanguageDictionary.new(language: :es, file: "#{path}/es-language.txt")
  dm << LittleWeasel::RegionDictionary.new(language: :es, region: :es, file: "#{path}/es-ES-region.txt")

  puts
  puts "DictionaryManager#count: #{dm.count}"
  puts "DictionaryManager#to_hash:"
  puts JSON.pretty_generate(dm.to_hash)
  puts "DictionaryManager#to_array: #{dm.to_array}"

  puts
  puts "DictionaryManager#reset"
  puts "DictionaryManager#count: #{dm.count}"
rescue StandardError => e
  task 'lw' do
    puts e.backtrace
    puts "LittleWeasel task lw not loaded: #{e.message}"
    exit 1
  end
end

task :workflow do
  require 'json'
  require_relative 'lib/LittleWeasel'
  LittleWeasel.configure do |config|
    # TODO: Configure as needed here.
  end
  path = 'spec/support/files'
  dm = LittleWeasel::DictionaryManager.instance

  en = dm << LittleWeasel::LanguageDictionary.new(language: :en, file: "#{path}/en-language.txt")
  en_us = dm << LittleWeasel::RegionDictionary.new(language: :en, region: :us, file: "#{path}/en-US-region.txt")

  dictionaries = Search.new(en, en_us)
  dictionaries.check('zebra', [:capitalize])

rescue StandardError => e
  task 'workflow' do
    puts "LittleWeasel task workflow not loaded: #{e.message}"
    exit 1
  end
end

task default: :spec
