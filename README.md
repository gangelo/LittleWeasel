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
:octocat:
At its most basic level, there are two (3) steps to using LittleWeasel:
- [ ] Create a **LittleWeasel::Dictionary**.
- [ ] Consume the **LittleWeasel::Dictionary#word_results** and/or **LittleWeasel::Dictionary#block_results** APIs to obtain a **LittleWeasel::WordResults** [^1] object for a particular word or word block. 
- [ ] Interrogate the **LittleWeasel::WordResults** [^1] object returned from either of the aforementioned APIs.

Some of the more advanced LittleWeasel features include the use of **word preprocessors**, **word filters** and **dictionary metadata modules**.

[^1]: The _LittleWeasel::WordResults_ object returned from these APIs provides information related to the given word or words that have passed through their respective processes (i.e. word preprocessing, word filtering and dictionary checks).

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

#### Using the Dictionary#word_results API

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

#### Using the Dictionary#block_results API

```ruby
# Using the "en_us_dictionary" dictionary created in the 
# "Creating a Dictionary from a File on Disk" example above...

word_filters = [LittleWeasel::Filters::EnUs::NumericFilter.new]
en_us_dictionary.add_preprocessors word_filters: word_filters

# Do a word block search...

word_block = "This is a word-block of 8 words and 2 numbers."

word_results = en_us_dictionary.word_block word_block
# Returns an Array of LittleWeasel::WordResults objects. 
# The below word_results object output is formatted for readability:
#=> 
word_results for word: 'This'...
word_results #=>
  # The word before any word preprocessors have been applied.
  #original_word: This
  
  # The word after all word preprocessors have been applied against
  # the word.
  #preprocessed_word: 
  
  # Indicates whether or not the word was found in the literal
  # dictionary (#word_valid?) OR if the word (after word preprocessing)
  # was matched against a word filter (#filter_match?).
  #success?: false
  
  # Indicates whether or not word (after word preprocessing) was found 
  # in the literal dictionary.
  #word_valid?: false
  
  # Indicates whether or not the word is cached, either as a word found
  # in the literal dictionary OR as an invalid word. The latter will
  # only take place if LittleWeasel::Configuration#max_invalid_words_bytesize
  # is greater than 0.
  #word_cached?: false
  
  # Indicates whether or not #preprocessed_word is present due to
  # word having passed through one or more word preprocessors. This
  # will only return true if word preprocessors are available to the
  # dictionary, turned on
  # (LittleWeasel::Preprocessors::WordPreprocessor#preprocessor_on?)
  # AND the word meets the criteria for word preprocessing for one or
  # more word preprocessors (LittleWeasel::Preprocessors::WordPreprocessor#preprocess?).
  #preprocessed_word?: false
  
  # Returns #preprocessed_word if word preprocessing has been applied
  # or original_word if word preprocessing has NOT been applied.
  #preprocessed_word_or_original_word: This
  
  # Indicates whether or not word has been matched by at least 1 
  # word filter.
  #filter_match?: false
  
  # Indicates the word filters that were matched against
  # word (LittleWeasel::Filters::WordFilter#filter_match?). If
  # word did not match any word filters, an empty Array is returned.
  #filters_matched: []

  # Indicates the word preprocessors that were applied against
  # word. If no word preprocessors were applied to word, an empty
  # Array is returned.
  #preprocessed_words: []

word_results for word: 'is'...
word_results #=>
  #original_word: is
  #preprocessed_word: 
  #success?: true
  #word_valid?: true
  #word_cached?: true
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: is
  #filter_match?: false
  #filters_matched: []
  #preprocessed_words: nil

word_results for word: 'a'...
word_results #=>
  #original_word: a
  #preprocessed_word: 
  #success?: true
  #word_valid?: true
  #word_cached?: true
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: a
  #filter_match?: false
  #filters_matched: []
  #preprocessed_words: nil

word_results for word: 'word-block'...
word_results #=>
  #original_word: word-block
  #preprocessed_word: 
  #success?: false
  #word_valid?: false
  #word_cached?: false
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: word-block
  #filter_match?: false
  #filters_matched: []
  #preprocessed_words: nil

word_results for word: 'of'...
word_results #=>
  #original_word: of
  #preprocessed_word: 
  #success?: false
  #word_valid?: false
  #word_cached?: false
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: of
  #filter_match?: false
  #filters_matched: []
  #preprocessed_words: nil

word_results for word: '8'...
word_results #=>
  #original_word: 8
  #preprocessed_word: 
  #success?: true
  #word_valid?: false
  #word_cached?: false
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: 8
  #filter_match?: true
  #filters_matched: [:numeric_filter]
  #preprocessed_words: nil

word_results for word: 'words'...
word_results #=>
  #original_word: words
  #preprocessed_word: 
  #success?: true
  #word_valid?: true
  #word_cached?: true
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: words
  #filter_match?: false
  #filters_matched: []
  #preprocessed_words: nil

word_results for word: 'and'...
word_results #=>
  #original_word: and
  #preprocessed_word: 
  #success?: true
  #word_valid?: true
  #word_cached?: true
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: and
  #filter_match?: false
  #filters_matched: []
  #preprocessed_words: nil

word_results for word: '2'...
word_results #=>
  #original_word: 2
  #preprocessed_word: 
  #success?: true
  #word_valid?: true
  #word_cached?: true
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: 2
  #filter_match?: true
  #filters_matched: [:numeric_filter]
  #preprocessed_words: nil

word_results for word: 'numbers'...
word_results #=>
  #original_word: numbers
  #preprocessed_word: 
  #success?: false
  #word_valid?: false
  #word_cached?: false
  #preprocessed_word?: false
  #preprocessed_word_or_original_word: numbers
  #filter_match?: false
  #filters_matched: []
  #preprocessed_words: nil
```

### Word Search using Word Filters and Word Preprocessors Example

Note: The below use of _word filters_ and _word preprocessors_ apply equally to both
**Dictionary#word_results** and **Dictionary#block_results** APIs.

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

## Word Blocks

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
