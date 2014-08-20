require 'engineyard-cloud-client'
require 'yaml'

module EySecrets
  class EngineYard
    def self.applications
      new.applications
    end

    def applications
      api.apps.map do |ey_app|
        application_from(ey_app)
      end
    end

    private

    def application_from(ey_app)
      Application.new(ey_app.name, ey_app.repository_uri, environments_from(ey_app))
    end

    def environments_from(ey_app)
      ey_app.app_environments.map do |ey_app_environment|
        environment_from(ey_app, ey_app_environment.environment)
      end
    end

    def environment_from(ey_app, ey_environment)
      Environment.new(ey_environment.name, instances_from(ey_app, ey_environment))
    end

    def instances_from(ey_app, ey_environment)
      ey_environment.instances.map do |ey_instance|
        Instance.new(ey_instance.hostname, ey_environment.username, ey_app.name)
      end
    end

    def api
      EY::CloudClient.new(token: api_token)
    end

    def api_token
      begin
        YAML.load_file(File.join(ENV['HOME'], '.eyrc'))['api_token']
      rescue
        raise 'API Token not found. Please configure the engine yard cli.'
      end
    end
  end
end
