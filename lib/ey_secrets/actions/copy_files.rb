module EySecrets
  class CopyFiles < Struct.new(:instance, :repository, :options)
    include CommandBuilder

    def build
      ensure_config_dir!
      copy_env_files
    end

    private

    def ensure_config_dir!
      ssh("if [ ! -d #{instance.shared_config_dir} ]; then mkdir -p #{instance.shared_config_dir}; fi")
    end

    def copy_env_files
      env_files.each do |file|
        scp(file, File.join(instance.shared_config_dir, File.basename(file)))
      end
    end

    def env_files
      repository.glob("#{instance.environment.name}/*")
    end
  end
end
