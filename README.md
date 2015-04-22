# sphinxtrain-ruby

[![Build Status](http://img.shields.io/travis/watsonbox/sphinxtrain-ruby.svg?style=flat)](https://travis-ci.org/watsonbox/sphinxtrain-ruby)

Toolkit for training/adapting CMU Sphinx acoustic models.

The main goal is to help with [adapting existing acoustic models](http://cmusphinx.sourceforge.net/wiki/tutorialadapt) to a specific speaker/accent. Currently only the English [Voxforge](http://voxforge.org/) model is supported as a base - in fact [an adapted one](http://grasch.net/node/21) created by Peter Grasch in 2013 using the most up to date training data available at that time. I can confirm his results of a few percent performance increase over Voxforge 0.4 for my accent at least (British English).


## Installation

Please note that Ruby >= 2.1 is required for this gem.

Add this line to your application's Gemfile:

```ruby
gem 'sphinxtrain-ruby'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install sphinxtrain-ruby
```


## Usage

Run `sphinxtrain-ruby` from the command line and follow the instructions.  It will:

1. Download and extract the Grasch Voxforge English 0.4 acoustic model (on first run)
2. Download the CMU ARCTIC example sentences (on first run)
3. Record the 20 example sentences. Press enter to record, speak sentence, then wait.
4. Decode the sentences using the base acoustic model, giving an overall score.
5. Duplicate and adapt the base acoustic model using the recorded sentences.
6. Decode the sentences using the adapted acoustic model, giving an overall score.

See some example output [here](https://github.com/watsonbox/sphinxtrain-ruby/wiki/Example-Output). All data is saved in `~/.sphinxtrain-ruby`.


## To Do

- [ ] Add support for different data sets, not just the example from CPU Sphinx
- [ ] Allow re-recording when mistakes are made
- [ ] Re-factor code and add specs
- [ ] Consider using actual libs rather than command line tools for adapting model
- [ ] Make command line wget downloads less verbose


## Contributing

1. Fork it ( https://github.com/watsonbox/sphinxtrain-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
