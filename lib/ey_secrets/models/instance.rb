require 'rainbow'

module EySecrets
  class Instance < Struct.new(:host_name, :user_name, :app_name)
    attr_accessor :environment

    def shared_config_dir
      "/data/#{app_name}/shared/config"
    end

    def current_app_dir
      "/data/#{app_name}/current/"
    end
  end
end
