[![GitHub version](http://badge.fury.io/gh/gangelo%2FLittleWeasel.svg)](https://badge.fury.io/gh/gangelo%2FLittleWeasel)
[![Gem Version](https://badge.fury.io/rb/LittleWeasel.svg)](https://badge.fury.io/rb/LittleWeasel)

[![](http://ruby-gem-downloads-badge.herokuapp.com/LittleWeasel?type=total)](http://www.rubydoc.info/gems/LittleWeasel/)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/LittleWeasel/)

[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/simple_command_dispatcher/issues)

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

# LittleWeasel

**LittleWeasel** is _more_ than just a spell checker for words (and word blocks, i.e. groups of words); LittleWeasel provides information about a particular word(s) through its API. LittleWeasel allows you to apply preprocessing to words through any number of word preprocessors _before_ they are checked against the dictionary(ies) you provide. In addition to this, you may provide any number of word filters that allow you to consider the validity of each word being checked, regardless of whether or not it's literally found in the dictionary. LittleWeasel will tell you exactly what word preprocessors were applied to a given word, even showing you the transformation of the original word as it passes through each preprocessor; it will also inform you of each matching word filters along the way, so you can make a decision about every word being validated. 

LittleWeasel provides other features as well:

* LittleWeasel allows you to provide any number of "dictionaryies" which may be in the form of a collecton of words in a file on disk _or_ an Array of words you provide, so that dictionaries may be created _dynamically_.
* Dictionaries are identified by a unique "dictionary key"; that is, a key based on locale (<language>-<REGION>, e.g. en-US) and/or optional "tag" (en-US-<tag>, e.g. en-US-slang). 
* Dictionaries are cached; their words and metadata are shared across dictionary instances that share the same dictionary key.
* Dictionaries can have observable, metadata objects attached to them which are notified when a word or word block is being evaluated; therefore, metadata about the dictionary, words, etc. can be gathered and used. For example, LittleWeasel uses a LittleWeasel::Metadata::InvalidWordsMetadata metadata object that caches and keeps track of the total bytes of invalid words searched against the dictionary. If the total bytes of invalid words exceeds what is set in the configuration, caching of invalid words ceases. You can create your own metadata objects to gather and use your own metadata.

## Usage

At its most basic level, there are two (2) steps to using LittleWeasel:
* Create one or more dictionaries.
* Use the LittleWeasl API to obtain a _LittleWeasel::WordResults_ (WordResults) object related to a given word or group of words (word block). A _WordResults_ object is simply a container object that encapsulates information related to said word (or word block words) having passed through the complete LittleWeasel word search process (i.e. word preprocessing, word filtering and dictionary word search).

Some of the more advanced LittleWeasel features include _word preprocesing_, _word filtering_ and dictionary metadata modules.

## Creating Dictionaries

### Creating a Dictionary from Memory
```ruby
# Create a Dictionary Manager.
dictionary_manager = LittleWeasel::DictionaryManager.new

# Create our unique key for the dictionary.
en_us_names_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us, tag: :names)

# Create a dictionary of names from memory.
en_us_names_dictionary = dictionary_manager.create_dictionary_from_memory(
  dictionary_key: en_us_names_key, dictionary_words: %w(Abel Bartholomew Cain Deborah Elijah))
```

### Creating a Dictionary from a File on Disk
```ruby
# Create a Dictionary Manager.
dictionary_manager = LittleWeasel::DictionaryManager.new

# Create our unique key for the dictionary.
en_us_key = LittleWeasel::DictionaryKey.new(language: :en, region: :us)

# Create a dictionary from a file on disk. 
#
# Dictionary files do not need to be named according to their locale and optional tag; 
# but, if they are, you can use DictionaryKey#key then simply append an optional file
# extension:
#
# dictionary_file_name = "dictionaries/#{en_us_key.key}.txt"
#=> dictionaries/en-US.txt
en_us_dictionary = dictionary_manager.create_dictionary_from_file(
  dictionary_key: en_us_key, file: "dictionaries/#{en_us_key.key}.txt")
```

### Basic Word Search Example

```ruby
# Using the "en_us_names_dictionary" dictionary created in the 
# "Creating a Dictionary from Memory" example above...

# Do some word searches...

word_results = en_us_names_dictionary.word_results 'Abel'
# Returns true because the 'Abel' is in the dictionary.
word_results.word_valid?
#=> true

word_results = en_us_names_dictionary.word_results 'elijah'
# Returns false because the 'Elijah' (not 'elijah') is in the dictionary.
word_results.word_valid?
#=> false
```

### Word Search using Word Filters and Word Preprocessors Example

```ruby
# Using the "en_us_names_dictionary" dictionary created in the 
# "Creating a Dictionary from Memory" example above...

# Set up any word preprocessors and/or word filters we want to use...

# Word preprocessors perform preprocessing on words prior to being passed through any word filters
# and prior to being checked against the literal dictionary words.
en_us_names_dictionary.add_preprocessors word_preprocessors: [LittleWeasel::Preprocessors::EnUs::CapitalizePreprocessor.new]

# Word filters check words for validity prior to being checked against the literal dictionary.
# In other words, word filters allow you to consider words valid (if they match the filter) despite not being found in the literal dictionary.
en_us_names_dictionary.add_filters word_filters: [LittleWeasel::Filters::EnUs::SingleCharacterWordFilter.new]

# Check some words against the dictionary; a LittleWeasel::WordResults object is returned...

# Try to find a name...
word_results = en_us_names_dictionary.word_results 'elijah'

# Returns true if the word is found in the literal dictionary (#word_valid?) or
# if the word matched any word filters (#filter_match?). true is returned because 
# 'elijah' ('Elijah' after preprocessing) was found in the literal dictionary,
# despite not having matched any word filters.
word_results.successful?
#=> true

# Returns true because 'elijah' ('Elijah' after preprocessing) was found in the 
# literal dictionary.
word_results.word_valid?
#=> true

# Returns true because the word had word preprocessing applied to it.
word_results.preprocessed_word?
#=> true

# Returns false because the word (after preprocessing) did not match any word filters.
word_results.filter_match?
#=> false

# Returns the original word, before any word preprocessors were applied.
word_results.original_word
#=> 'elijah'

# The resulting word after all word preprocessors have been applied.
word_results.preprocessed_word
#=> 'Elijah'
```

### Word filters and word preprocessors working together example...

```ruby
# This builds on the preceeding example...

# Search for a word that does not exist in the literal dictionary, but matches a filter...

# Because of the LittleWeasel::Filters::EnUs::SingleCharacterWordFilter word filter,
# "i" ("I" after word preprocessing) will be considered valid, even though it's not 
# literally found in the dictionary.
word_results = en_us_names_dictionary.word_results 'i'

# true is returned because  'i' ('I' after preprocessing) was matched against the
# LittleWeasel::Filters::EnUs::SingleCharacterWordFilter word filter, despite not
# having been found in the literal dictionary.
word_results.successful?
#=> true

# Returns false because 'i' ('I' after preprocessing) was not found in the 
# literal dictionary.
word_results.word_valid?
#=> false

# Returns true because 'i' ('I' after preprocessing) had word preprocessing applied to it.
word_results.preprocessed_word?
#=> true

# Returns true because the 'i' ('I' after preprocessing) matched the LittleWeasel::Filters::EnUs::SingleCharacterWordFilter word filter.
word_results.filter_match?
#=> true

# Returns the original word, before any word preprocessors were applied.
word_results.original_word
#=> 'i'

# The resulting word after all word preprocessors have been applied.
word_results.preprocessed_word
#=> 'I'
```
## Installation

Add this line to your application's Gemfile:

    gem 'LittleWeasel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install LittleWeasel

## Contributing

Not taking contributions just yet.

## License

(The MIT License)

Copyright © 2013-2021 Gene M. Angelo, Jr.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
