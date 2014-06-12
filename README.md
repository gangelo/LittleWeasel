# LittleWeasel

Simple spell checker using an english dictionary.
Forked from https://github.com/stewartmckee/spell_checker

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
