require "pocketsphinx-ruby"
require "pastel"
require "word_aligner"

require "sphinxtrain/version"
require "sphinxtrain/analyser"
require "sphinxtrain/map_adapter"
require "sphinxtrain/acoustic_model"
require "sphinxtrain/training_decoder"
require "sphinxtrain/trainer"

module Sphinxtrain
  def self.base_dir
    File.join(Dir.home, '.sphinxtrain-ruby')
  end

  def self.recordings_dir
    File.join(base_dir, 'recordings')
  end
end
