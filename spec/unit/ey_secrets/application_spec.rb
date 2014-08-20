require 'spec_helper'

module EySecrets
  describe Application do
    describe '#config_repository_uri' do
      it 'inserts config suffix into repository_uri' do
        application = Application.new('my_app', 'git@git.example.com:my_app.git')

        expect(application.config_repository_uri).to eq('git@git.example.com:my_app_config.git')
      end
    end
  end
end
