module EySecrets
  class Repository < Struct.new(:remotes, :files, :ready_for_update)
    class NotReadyForUpdate < Error
    end

    def ready_for_update?
      ready_for_update
    end

    def glob(pattern)
      files.select { |file| File.fnmatch(pattern, file) }
    end

    def assert_ready_for_update
      unless ready_for_update?
        raise(NotReadyForUpdate,
              'Commit on master and push your changes before updating config.' \
              "\n\n" \
              'Config can only be updated from the master branch. ' \
              'This helps ensure that the credentials found on a production ' \
              'system always reflect the current state of the master branch.')
      end
    end
  end
end
