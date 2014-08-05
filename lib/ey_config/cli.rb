require 'thor'
require 'rainbow'

module EyConfig
  class Cli < Thor
    method_option 'environment', aliases: '-e', type: :string, required: true, banner: 'Environment to update.'
    method_option 'app', aliases: '-a', type: :string, banner: 'App to update.'
    desc 'update', 'Copy config files from deploy/config to instances.'
    def update
      config_repository.assert_clean!
      environment = Environment.find!(options.merge(remotes: app_repository.remotes))

      environment.instances.each do |instance|
        puts Rainbow("Copying config to #{instance.hostname}").blue

        instance.ensure_config_dir!
        instance.sync(config_repository.glob(File.join(environment.name, '*.env')))
        instance.restart
      end
    end

    desc 'pull', 'Clone or pull config repository.'
    def pull
      if config_repository.exists?
        puts Rainbow("Pulling #{config_repository.path}...").green
        config_repository.pull
      else
        puts Rainbow("Cloning #{config_repository_uri} to #{config_repository.path}...").green
        config_repository.clone(config_repository_uri)
      end
    end

    desc 'commit', 'Commit changes in config repository.'
    def commit
      config_repository.commit
    end

    desc 'push', 'Push commits from config repository.'
    def push
      config_repository.push
    end

    private

    def app_repository
      Repository.new('.')
    end

    def config_repository
      Repository.new('deploy/config')
    end

    def config_repository_uri
      app_repository.remotes.first.gsub(/.git$/, '_config.git')
    end
  end
end
