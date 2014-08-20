module EySecrets
  class Update < Struct.new(:application, :repository, :options)
    include CompositeCommandBuilder

    def build
      repository.assert_ready_for_update

      InstanceResolver.find!(application, options.merge(remotes: repository.remotes)).each do |instance|
        action CopyFiles.new(instance, repository, options)
        action Restart.new(instance, options)
      end
    end
  end
end
