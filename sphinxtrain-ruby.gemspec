# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sphinxtrain/version'

Gem::Specification.new do |spec|
  spec.name          = "sphinxtrain-ruby"
  spec.version       = Sphinxtrain::VERSION
  spec.authors       = ["Howard Wilson"]
  spec.email         = ["howard@watsonbox.net"]
  spec.summary       = %q{Toolkit for training/adapting CMU Sphinx acoustic models.}
  spec.description   = %q{Toolkit for training/adapting CMU Sphinx acoustic models.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "pocketsphinx-ruby", "~> 0.1.1"
  spec.add_dependency "word_aligner", "~> 0.1.2"
  spec.add_dependency "colorize", "~> 0.7.3"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "rake"
end
