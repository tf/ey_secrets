module EySecrets
  class InstanceResolver < Struct.new(:applications, :options)
    def self.find!(applications, options)
      new(applications, options).find!
    end

    def find!
      find_environment!.instances
    end

    private

    def find_environment!
      find_app!.environments.find do |environment|
        environment.name == options[:environment]
      end || raise("Could not find environment '#{options[:environment]}' for app '#{options[:app]}'.")
    end

    def find_app!
      find_app_by_name(options[:app]) ||
        find_app_by_remotes(options[:remotes]) ||
        raise("Could not find app with name '#{options[:name]}'.")
    end

    def find_app_by_name(name)
      applications.find do |application|
        application.name == name
      end
    end

    def find_app_by_remotes(remotes)
      applications.find do |application|
        remotes.include?(application.config_repository_uri)
      end
    end
  end
end
