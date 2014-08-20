require 'spec_helper'

module EySecrets
  describe InstanceResolver do
    describe '.find!' do
      it 'finds instances from specified environment' do
        production_instance = Instance.new('production.host', 'user', 'my_app')
        staging_instance = Instance.new('staging.host', 'user', 'my_app')
        applications = [
          Application.new('my_app', 'git@git.example.com:my_app.git', [
                            Environment.new('staging', [staging_instance]),
                            Environment.new('production', [production_instance])
                          ])
        ]
        options = {app: 'my_app', environment: 'production'}

        instances = InstanceResolver.find!(applications, options)

        expect(instances).to eq([production_instance])
      end

      it 'finds instances from specified application' do
        app_instance = Instance.new('app.host', 'user', 'my_app')
        other_app_instance = Instance.new('other.host', 'user', 'my_app')
        applications = [
          Application.new('my_app', 'git@git.example.com:my_app.git', [
                            Environment.new('production', [app_instance])
                          ]),
          Application.new('other_app', 'git@git.example.com:other.git', [
                            Environment.new('production', [other_app_instance])
                          ])
        ]
        options = {app: 'my_app', environment: 'production'}

        instances = InstanceResolver.find!(applications, options)

        expect(instances).to eq([app_instance])
      end

      it 'finds instances from application with specified remotes' do
        app_instance = Instance.new('app.host', 'user', 'my_app')
        other_app_instance = Instance.new('other.host', 'user', 'my_app')
        applications = [
          Application.new('my_app', 'git@git.example.com:my_app.git', [
                            Environment.new('production', [app_instance])
                          ]),
          Application.new('other_app', 'git@git.example.com:other.git', [
                            Environment.new('production', [other_app_instance])
                          ])
        ]
        options = {remotes: ['git@git.example.com:my_app_config.git'], environment: 'production'}

        instances = InstanceResolver.find!(applications, options)

        expect(instances).to eq([app_instance])
      end
    end
  end
end
