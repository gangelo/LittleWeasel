[![GitHub version](http://badge.fury.io/gh/gangelo%2FLittleWeasel.svg)](https://badge.fury.io/gh/gangelo%2FLittleWeasel)
[![Gem Version](https://badge.fury.io/rb/LittleWeasel.svg)](https://badge.fury.io/rb/LittleWeasel)

[![](http://ruby-gem-downloads-badge.herokuapp.com/LittleWeasel?type=total)](http://www.rubydoc.info/gems/LittleWeasel/)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/LittleWeasel/)

[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/simple_command_dispatcher/issues)

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

# LittleWeasel

LittleWeasel is _more_ than just a spell checker for words (and word blocks, i.e. groups of words); LittleWeasel provides information about a particular word(s) through its api. LittleWeasel allows you to apply preprocessing to words through any number of word preprocessors _before_ they are checked against the dictionary(ies) you provide. In addition to this, you may provide any number of word filters that allow you to consider the validity of each word being checked, regardless of whether or not it's literally found in the dictionary you provide. LittleWeasel will tell you exactly what word preprocessors were applied, even showing you the transformation of the original word as it passes through each preprocessor; it will also tell you each matching word filter along the way, so you can make a decision about each word that's checked.

## LittleWeasel Provides Other Features

* LittleWeasel allows you to provide one or more "dictionary(ies)" that may be in the form of a collecton of words found in a file on disk _or_ an Array of words you provide, so that dictionaries may be created _dynamically_.
* Dictionaries can have observable, metadata objects attached to them, that are notified when a word or block of words is being evaluated, so that metadata about the dictionary, words, etc. can be gathered and used. For example, LittleWeasel uses a LittleWeasel::Metadata::InvalidWordsMetadata metadata object that caches and keeps track of the total bytes of invalid words searched against the dictionary. If the total bytes of invalid words exceeds what is set in the configurtion, caching of invalid words ceases. You can create your own metadata objects to gather and use your own data.
* The dictionary(ies) you provide are identified by a "dictionary key", that is, a locale (<language>-<REGION>, e.g. en-US) and optional "tag" (en-US-<tag>, e.g. en-US-slang), that let you uniquely identify each dictionary - dictionaries are cached, their words and metadata are shared across dictionary instances that share the same dictionary key.

## Examples

### Creating a Dictionary from Memory

```ruby
require 'LittleWeasel'

# Create a Dictionary Manager.
dictionary_manager = LittleWeasel::DictionaryManager.new

# Create our unique key for the dictionary.
en_us_names_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us, tag: :names)

# Set up any word preprocessors and/or word filters we want to use...

# Word preprocessors perform preprocessing on words prior to being passed through any word filters
# and prior to being checked against the literal dictionary words.
word_preprocessors = [LittleWeasel::Preprocessors::EnUs::CapitalizePreprocessor.new]

# Word filters check words for validity prior to being checked against the literal dictionary.
# In other words, word filters allow you to consider words valid (if they match the filter) despite not being found in the literal dictionary.
word_filters = [LittleWeasel::Filters::EnUs::SingleCharacterWordFilter.new]

# Create a dictionary of names from memory.
names_dictionary = dictionary_manager.create_dictionary_from_memory(dictionary_key: en_us_names_key, dictionary_words: %w(Able Bartholomew Cain Deborah Elijah), word_filters: word_filters, word_preprocessors: word_preprocessors)

# Check some words against the dictionary.
word_results = names_dictionary.word_results 'elijah'

#=>
```

## Installation

Add this line to your application's Gemfile:

    gem 'LittleWeasel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install LittleWeasel

## Usage

require 'LittleWeasel'

LittleWeasel::Checker.instance.exists?('word', options|nil) # true if exists in the dictionary, false otherwise.

LittleWeasel::Checker.instance.exists?('Multiple words', options|nil) # true if exists in the dictionary, false otherwise.

## Contributing

Not taking contributions just yet.

## License

(The MIT License)

Copyright © 2013-2014 Gene M. Angelo, Jr.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
