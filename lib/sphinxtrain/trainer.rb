require 'fileutils'

module Sphinxtrain
  class Trainer
    def acoustic_model
      @acoustic_model ||= AcousticModel.voxforge_grasch
    end

    def train
      Pocketsphinx.disable_logging

      Dir.mkdir Sphinxtrain.base_dir rescue Errno::EEXIST
      Dir.chdir Sphinxtrain.base_dir do
        if acoustic_model.downloaded?
          log "=> Using existing acoustic model #{acoustic_model.description}", :yellow
        else
          log "=> Downloading #{acoustic_model.description}..."
          acoustic_model.download!
        end

        download_assets unless arctic_file(:txt, :listoffiles, :transcription, :dic).all? { |f| File.exist? f }

        if Dir.exist?(Sphinxtrain.recordings_dir)
          log "=> Using sentences recorded in #{Sphinxtrain.recordings_dir}", :yellow
        else
          record_sentences
        end

        result = analyse_model

        duplicate_model
        adapt_model

        adapted_result = analyse_model acoustic_model.adapted_folder

        improvement = ((adapted_result/result)-1)*100

        log "=> Adapted acoustic model improved by #{improvement}%. Test this model with:"
        log "=> pocketsphinx_continuous -hmm #{File.join(Sphinxtrain.base_dir, acoustic_model.adapted_folder)} -inmic yes"
      end
    end

    private

    def download_assets
      log "=> Downloading CMU ARCTIC Example Sentences..."

      arctic_file(:txt, :listoffiles, :transcription, :dic).each do |file|
        `wget http://www.speech.cs.cmu.edu/cmusphinx/moindocs/#{file} -O #{file}`
      end
    end

    def arctic_file(*keys)
      keys.length == 1 ? "arctic20.#{keys.first}" : keys.map { |k| arctic_file k }
    end

    def record_sentences
      log "=> Recording sentences..."
      Dir.mkdir Sphinxtrain.recordings_dir unless Dir.exist?(Sphinxtrain.recordings_dir)

      recognizer = Pocketsphinx::LiveSpeechRecognizer.new
      decoder = TrainingDecoder.new(recognizer.decoder)
      recognizer.decoder = decoder

      # Initialize the decoder and microphone
      recognizer.decoder.ps_decoder
      recognizer.recordable

      File.open(arctic_file(:txt), 'r').lines.each_with_index do |sentence, index|
        puts "SAY: #{sentence}"
        puts "Press ENTER to continue"
        gets

        # Small delay to avoid capturing audio connected with keypress
        sleep 0.2

        # Record a single utterance captured by TrainingDecoder
        recognizer.recognize do |speech|
          save_audio decoder.last_utterance, index
          break
        end

        puts "Saved audio\n\n"
      end
    end

    def save_audio(data, sentence_index)
      raise "Can't save empty audio data" if data.nil? || data.empty?

      File.open(File.join(Sphinxtrain.recordings_dir, "arctic_#{(sentence_index + 1).to_s.rjust(4, "0")}.raw"), "wb") do |file|
        file.write data
      end
    end

    def analyse_model(model_folder = acoustic_model.folder)
      log "=> Analysing acoustic model...\n"

      result = Analyser.new(model_folder).analyse(arctic_file(:txt), Sphinxtrain.recordings_dir) do |transcription, hypothesis, accuracy|
        puts "   ACTUAL: #{transcription}"
        puts "   RECORD: #{hypothesis}"
        puts "   RESULT: #{accuracy}\n\n"
      end

      puts "   OVERALL: #{result}\n\n"
      result
    end

    def duplicate_model
      log "=> Duplicating Voxforge acoustic model..."
      acoustic_model.duplicate!
    end

    # Follows process described here: http://cmusphinx.sourceforge.net/wiki/tutorialadapt
    def adapt_model
      log "=> Adapting Voxforge acoustic model..."

      MapAdapter.new(
        old_model: acoustic_model.folder,
        new_model: acoustic_model.adapted_folder,
        recordings_dir: Sphinxtrain.recordings_dir,
        sentences_transcription: arctic_file(:transcription),
        sentences_files: arctic_file(:listoffiles),
        sentences_dict: arctic_file(:dic)
      ).adapt
    end

    def log(message, color = :green)
      puts message.colorize(color)
    end
  end
end
