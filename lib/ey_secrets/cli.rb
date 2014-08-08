require 'thor'
require 'rainbow'

module EySecrets
  class Cli < Thor
    method_option 'environment', aliases: '-e', type: :string, required: true, banner: 'Environment to update.'
    method_option 'app', aliases: '-a', type: :string, banner: 'App to update.'
    desc 'update', 'Copy config files from deploy/config to instances.'
    def update
      repository.assert_clean!
      environment = Environment.find!(options.merge(remotes: repository.remotes))

      environment.instances.each do |instance|
        puts Rainbow("Copying config to #{instance.hostname}").blue

        instance.ensure_config_dir!
        instance.sync(config_repository.glob(File.join(environment.name, '*.env')))
        instance.restart
      end
    end

    desc 'version', 'Display version information'
    def version
      puts Rainbow("EySecrets version #{VERSION}").green
    end
    map '-v' => :version

    private

    def repository
      Repository.new('.')
    end
  end
end
