module Sphinxtrain
  class MapAdapter
    SPHINX_FE_COMMAND = "sphinx_fe"
    BW_COMMAND = "/usr/local/Cellar/cmu-sphinxtrain/HEAD/libexec/sphinxtrain/bw"
    MAP_ADAPT_COMMAND = "/usr/local/Cellar/cmu-sphinxtrain/HEAD/libexec/sphinxtrain/map_adapt"

    attr_accessor :old_model, :new_model, :recordings_dir, :sentences_transcription, :sentences_files, :sentences_dict

    def initialize(old_model:, new_model:, recordings_dir:, sentences_transcription:, sentences_files:, sentences_dict:)
      self.old_model = old_model
      self.new_model = new_model
      self.recordings_dir = recordings_dir
      self.sentences_transcription = sentences_transcription
      self.sentences_files = sentences_files
      self.sentences_dict = sentences_dict
    end

    def adapt
      `#{SPHINX_FE_COMMAND} \
        -argfile #{new_model_file 'feat.params'} \
        -samprate 16000 \
        -c #{sentences_files} \
        -di #{recordings_dir} \
        -do #{recordings_dir} \
        -ei raw \
        -eo mfc \
        -seed 1 > /dev/null 2>&1`

      `#{BW_COMMAND} \
        -hmmdir #{new_model} \
        -moddeffn #{new_model_file 'mdef'} \
        -ts2cbfn ".cont." \
        -feat 1s_c_d_dd \
        -cmn current \
        -agc none \
        -dictfn #{sentences_dict} \
        -ctlfn #{sentences_files} \
        -lsnfn #{sentences_transcription} \
        -accumdir #{recordings_dir} \
        -lda #{new_model_file 'feature_transform'} \
        -cepdir #{recordings_dir} > /dev/null 2>&1`

      `#{MAP_ADAPT_COMMAND} \
        -meanfn #{old_model_file 'means'} \
        -varfn #{old_model_file 'variances'} \
        -mixwfn #{old_model_file 'mixture_weights'} \
        -tmatfn #{old_model_file 'transition_matrices'} \
        -accumdir #{recordings_dir} \
        -mapmeanfn #{new_model_file 'means'} \
        -mapvarfn #{new_model_file 'variances'} \
        -mapmixwfn #{new_model_file 'mixture_weights'} \
        -maptmatfn #{new_model_file 'transition_matrices'} > /dev/null 2>&1`
    end

    private

    def old_model_file(file)
      File.join(old_model, file)
    end

    def new_model_file(file)
      File.join(new_model, file)
    end
  end
end
