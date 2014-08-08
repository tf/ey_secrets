require 'engineyard-cloud-client'
require 'yaml'

module EySecrets
  class Environment
    def initialize(ey_environment)
      @ey_environment = ey_environment

      ey_environment
    end

    def name
      ey_environment.name
    end

    def instances
      ey_environment.instances.map do |ey_instance|
        Instance.new(ey_instance.hostname, ey_environment.username, ey_environment.apps.first.name)
      end
    end

    def self.find!(options)
      Environment.new(Resolver.new.find!(options))
    end

    private

    attr_reader :ey_environment

    class Resolver
      def find!(options)
        environments_for_app(find_app!(options)).find do |environment|
          environment.name == options[:environment]
        end || raise("Could not find environment '#{options[:environment]}' for app '#{options[:app]}'.")
      end

      private

      def environments_for_app(app)
        app.app_environments.map(&:environment)
      end

      def find_app!(options)
        find_app_by_name(options[:name]) ||
          find_app_by_remotes(options[:remotes]) ||
          raise("Could not find app with name '#{options[:name]}'.")
      end

      def find_app_by_name(name)
        api.apps.find do |a|
          a.name == name
        end
      end

      def find_app_by_remotes(remotes)
        api.apps.find do |a|
          remotes.include?(a.repository_uri)
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
end
