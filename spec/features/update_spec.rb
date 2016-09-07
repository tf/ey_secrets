require 'spec_helper'

module EySecrets
  describe 'update' do
    def applications
      [
        Application.new('my_app', 'git@git.exmaple.com:my_app.git', [
                          Environment.new('production', [
                                            Instance.new('host', 'user', 'my_app')
                                          ])
                        ])
      ]
    end

    def repository(options = {})
      Repository.new(['git@git.exmaple.com:my_app_config.git'],
                     [
                       'production/secrets.env', 'staging/secrets.env',
                       'production/secrets.yml', 'staging/secrets.yml',
                       'production/secrets.json', 'staging/secrets.json',
                     ],
                     options.fetch(:ready_for_update, true))
    end

    it 'fails if repo is not ready for update' do
      options = {app: 'my_app', environment: 'production'}

      expect {
        Update.new(applications, repository(ready_for_update: false), options).commands
      }.to raise_error(Repository::NotReadyForUpdate)
    end

    it 'copies files from environment directory to instances' do
      options = {app: 'my_app', environment: 'production'}

      commands = Update.new(applications, repository, options).commands

      expect(commands).to include('scp production/secrets.env user@host:/data/my_app/shared/config/secrets.env')
      expect(commands).to include('scp production/secrets.yml user@host:/data/my_app/shared/config/secrets.yml')
      expect(commands).to include('scp production/secrets.json user@host:/data/my_app/shared/config/secrets.json')
    end

    it 'restarts monit' do
      options = {app: 'my_app', environment: 'production'}

      commands = Update.new(applications, repository, options).commands

      expect(commands).to include('ssh user@host "sudo monit restart -g my_app_resque"')
    end

    it 'restarts passenger' do
      options = {app: 'my_app', environment: 'production'}

      commands = Update.new(applications, repository, options).commands

      expect(commands).to include(a_string_matching('touch /data/my_app/current/tmp/restart.txt'))
    end
  end
end
