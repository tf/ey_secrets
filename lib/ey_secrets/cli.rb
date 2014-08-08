require 'thor'
require 'rainbow'

module EySecrets
  class Cli < Thor
    method_option 'environment', aliases: '-e', type: :string, required: true, banner: 'Environment to update.'
    method_option 'app', aliases: '-a', type: :string, banner: 'App to update.'
    desc 'update', 'Copy config files from deploy/config to instances.'
    def update
      repository.assert_clean!
      environment = Environment.find!(options.merge(remotes: app_remotes))

      environment.instances.each do |instance|
        puts Rainbow("Copying config to #{instance.hostname}").blue

        instance.ensure_config_dir!
        instance.sync(repository.glob(File.join(environment.name, '*.env')))
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

    def app_remotes
      repository.remotes.map do |remote|
        remote.gsub(/_config\.git$/, '.git')
      end
    end
  end
end
