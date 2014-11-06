# sphinxtrain-ruby

[![Build Status](http://img.shields.io/travis/watsonbox/sphinxtrain-ruby.svg?style=flat)](https://travis-ci.org/watsonbox/sphinxtrain-ruby)

Toolkit for training/adapting CMU Sphinx acoustic models.

The main goal is to help with [adapting existing acoustic models](http://cmusphinx.sourceforge.net/wiki/tutorialadapt) to a specific speaker/accent. Currently only the English [Voxforge](http://voxforge.org/) model is supported as a base - in fact [an adapted one](http://grasch.net/node/21) created by Peter Grasch in 2013 using the most up to date training data available at that time. I can confirm his results of a few percent performance increase over Voxforge 0.4 for my accent at least (British English).


## Installation

Add this line to your application's Gemfile:

    gem 'sphinxtrain-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sphinxtrain-ruby


## Usage

TODO: Write usage instructions here


## Contributing

1. Fork it ( https://github.com/watsonbox/sphinxtrain-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
