# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'LittleWeasel/version'

Gem::Specification.new do |spec|
  spec.name          = 'LittleWeasel'
  spec.version       = LittleWeasel::VERSION
  spec.authors       = ['Gene M. Angelo, Jr.']
  spec.email         = ['public.gma@gmail.com']
  spec.description   = 'Spellchecker+ with preprocessing and filtering for single and multiple word blocks.'
  spec.summary       = 'Checks a word or group of words for validity against a dictionary/ies provided. Word filtering and word preprocessing is available.'
  spec.homepage      = 'http://www.geneangelo.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 3.0', '>= 3.0.1'
  spec.add_runtime_dependency 'activesupport', '~> 6.1', '>= 6.1.3.2'
  spec.add_development_dependency 'benchmark-ips', '~> 2.3'
  spec.add_development_dependency 'bundler', '~> 2.2', '>= 2.2.17'
  spec.add_development_dependency 'factory_bot', '~> 6.2'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'redcarpet', '~> 3.5', '>= 3.5.1'
  spec.add_development_dependency 'reek', '~> 6.0', '>= 6.0.4'
  spec.add_development_dependency 'rspec', '~> 3.10'
  # This verson of rubocop is returning errors.
  # spec.add_development_dependency 'rubocop', '~> 1.14'
  spec.add_development_dependency 'rubocop', '~> 1.9.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11', '>= 1.11.3'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  # Needed for yard
  spec.add_development_dependency 'webrick', '~> 1.7'
  spec.add_development_dependency 'yard', '~> 0.9.26'
end
