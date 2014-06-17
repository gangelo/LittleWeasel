# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'LittleWeasel/version'

Gem::Specification.new do |spec|
  spec.name          = "LittleWeasel"
  spec.version       = LittleWeasel::VERSION
  spec.authors       = ["Gene M. Angelo, Jr."]
  spec.email         = ["public.gma@gmail.com"]
  spec.description   = %q{Simple spellchecker for single, or multiple word blocks.}
  spec.summary       = %q{Simply checks a word or group of words for validity against an english dictionary file.}
  spec.homepage      = "http://www.geneangelo.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0.0'
  spec.add_runtime_dependency 'activesupport', '~> 4.1.1'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "yard", "0.8.6.1"
  spec.add_development_dependency "redcarpet", "~> 2.3.0"
end
