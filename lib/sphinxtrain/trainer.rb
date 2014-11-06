module Sphinxtrain
  class Trainer
    BASE_DIR = File.join(Dir.home, '.sphinxtrain-ruby')
    VOXFORGE_URL = "http://downloads.sourceforge.net/project/cmusphinx/Acoustic%20and%20Language%20Models/English%20Voxforge/voxforge-en-0.4.tar.gz"
    VOXFORGE_FILE = File.basename(VOXFORGE_URL)
    VOXFORGE_FOLDER = File.basename(VOXFORGE_FILE, '.tar.gz')
    VOXFORGE_MODEL = File.join(BASE_DIR, VOXFORGE_FOLDER, "model_parameters/voxforge_en_sphinx.cd_cont_5000")
    RECORDINGS_DIR = File.join(BASE_DIR, 'recordings')

    def train
      Pocketsphinx.disable_logging

      Dir.mkdir BASE_DIR rescue Errno::EEXIST
      Dir.chdir BASE_DIR do
        download_voxforge unless File.exist?(VOXFORGE_FILE)
        download_assets unless arctic_file(:txt, :listoffiles, :transcription, :dic).all? { |f| File.exist? f }
        record_sentences unless Dir.exist?(RECORDINGS_DIR)
      end
    end

    private

    def download_voxforge
      log "=> Downloading Voxforge English 0.4 Acoustic Model..."
      `wget #{VOXFORGE_URL}`
      `tar xfz #{VOXFORGE_FILE}`
    end

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
      Dir.mkdir RECORDINGS_DIR unless Dir.exist?(RECORDINGS_DIR)

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
        sleep 0.2 if index != 0

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

      File.open(File.join(RECORDINGS_DIR, "arctic_#{(sentence_index + 1).to_s.rjust(4, "0")}.raw"), "wb") do |file|
        file.write data
      end
    end

    def log(message)
      puts message.colorize(:green)
    end
  end
end
