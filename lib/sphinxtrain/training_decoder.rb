module Sphinxtrain
  class TrainingDecoder < SimpleDelegator
    attr_accessor :data
    attr_accessor :last_utterance

    def start_utterance(*args)
      self.data = ""

      super
    end

    def end_utterance(*args)
      speech_stopped

      super
    end

    def process_raw(buffer, size, *args)
      super

      speech_started if in_speech?

      self.data << buffer.get_bytes(0, size * 2)
    end

    private

    def speech_started
      return if data.nil? || @speech_started

      @speech_started = true

      # Remove all but the last half second or so of audio
      self.data = data[-8000..-1].to_s
    end

    def speech_stopped
      @speech_started = false
      self.last_utterance = data
    end
  end
end
