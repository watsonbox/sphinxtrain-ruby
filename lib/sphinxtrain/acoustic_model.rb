module Sphinxtrain
  class AcousticModel < Struct.new(:url)
    MODEL_URLS = {
      voxforge_grasch: "http://files.kde.org/accessibility/Simon/am/voxforge_en_sphinx.cd_cont_5000.tar.gz"
    }

    MODEL_DESCRIPTIONS = {
      voxforge_grasch: "Grasch Voxforge English 0.4"
    }

    def self.voxforge_grasch
      new MODEL_URLS[:voxforge_grasch]
    end

    def description
      MODEL_DESCRIPTIONS[MODEL_URLS.invert[url]] || url
    end

    def base_dir
      File.join(Dir.home, '.sphinxtrain-ruby')
    end

    def downloaded?
      File.exist?(downloaded_filename)
    end

    def downloaded_filename
      File.basename(url)
    end

    def folder
      File.basename(downloaded_filename, '.tar.gz')
    end

    def adapted_folder
      folder + "_adapted"
    end

    def download!
      `wget #{url}`
      `tar xfz #{downloaded_filename}`
    end

    def duplicate!
      FileUtils.rm_rf(adapted_folder) if Dir.exist?(adapted_folder)
      FileUtils.cp_r(folder, adapted_folder)
    end
  end
end
