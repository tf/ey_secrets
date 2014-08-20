require 'thor'
require 'rainbow'

module EySecrets
  class Cli < Thor
    method_option 'environment', aliases: '-e', type: :string, required: true, banner: 'Environment to update.'
    method_option 'app', aliases: '-a', type: :string, banner: 'App to update.'
    method_option 'dry-run', aliases: '-n', type: :boolean, banner: 'Only print commands do not execute.'
    desc 'update', 'Copy config files from deploy/config to instances.'
    def update
      Shell.execute!(Update.new(EngineYard.applications, Git.repository('.'), options), options) do |command|
        puts(Rainbow(command).green)
      end
    rescue Error => e
      puts(Rainbow(e.message).red)
      exit 1
    end

    desc 'version', 'Display version information'
    def version
      puts Rainbow("EySecrets version #{VERSION}").green
    end
    map '-v' => :version
  end
end
