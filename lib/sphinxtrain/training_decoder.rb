module Sphinxtrain
  # Wrap a decoder to save the last utterance
  class TrainingDecoder < SimpleDelegator
    attr_accessor :data
    attr_accessor :last_utterance

    def start_utterance(*args)
      self.data = ""
      super
    end

    def end_utterance(*args)
      self.last_utterance = data
      super
    end

    def process_raw(buffer, size, *args)
      super
      self.data << buffer.get_bytes(0, size * 2)
    end
  end
end
