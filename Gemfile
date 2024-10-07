# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in LittleWeasel.gemspec
gemspec

group :development, :test do
  gem 'factory_bot', '>= 6.3', '< 7.0'
  gem 'pry-byebug', '>= 3.9', '< 4.0'
  gem 'reek', '>= 6.0', '< 7.0'
  gem 'rspec', '>= 3.12', '< 4.0'
  gem 'rubocop', '>= 1.56', '< 2.0'
  gem 'rubocop-performance', '>= 1.19', '< 2.0'
  gem 'rubocop-rspec', '~> 3.1'
  gem 'simplecov', '>= 0.22.0', '< 1.0'
end

group :benchmarking do
  gem 'benchmark-ips', '>= 2.3', '< 3.0'
end

group :documentation do
  # Needed for yard
  gem 'webrick', '>= 1.7', '< 2.0'
  gem 'yard', '>= 0.9.26', '< 1.0'
end

# Global gems, commonly used in development but not necessarily tied to a specific task
gem 'bundler', '~> 2.5', '>= 2.5.3'
gem 'rake', '>= 13.0', '< 14'
gem 'redcarpet', '>= 3.5', '< 4.0'
