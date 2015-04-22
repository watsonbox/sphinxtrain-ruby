module Sphinxtrain
  class Analyser
    def initialize(model)
      configuration['hmm'] = model
      configuration['seed'] = 1 # Ensure deterministic results
    end

    def analyse(sentences_file, recordings_dir)
      total = 0
      first_decoding = true

      File.open(sentences_file).each_line.with_index do |transcription, index|
        transcription = transcription.downcase.gsub(/[,\.]/, '')
        file_path = File.join(recordings_dir, "arctic_#{(index + 1).to_s.rjust(4, "0")}.raw")
        decoder.decode file_path

        # Repeat the first decoding after CMN estimations are calculated
        # See https://github.com/watsonbox/pocketsphinx-ruby/issues/10
        if first_decoding
          first_decoding = false
          redo
        end

        hypothesis = decoder.hypothesis
        error_rate = WordAligner.align(transcription, hypothesis)
        total += error_rate.percentage_accurate

        if block_given?
          yield transcription, hypothesis, error_rate.percentage_accurate
        end
      end

      total / 20
    end

    private

    def configuration
      @configuration ||= Pocketsphinx::Configuration.default
    end

    def decoder
      @decoder ||= Pocketsphinx::Decoder.new(configuration)
    end
  end
end
