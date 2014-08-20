module EySecrets
  class Application < Struct.new(:name, :repository_uri, :environments)
    def config_repository_uri
      repository_uri.gsub(/\.git$/, '_config.git')
    end
  end
end
