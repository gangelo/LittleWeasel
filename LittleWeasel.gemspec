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
  spec.homepage      = 'https://github.com/gangelo/LittleWeasel'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.1', '< 4.0')

  spec.add_runtime_dependency 'activesupport', '>= 7.0.8', '< 8.0'
end
