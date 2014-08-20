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
        raise(NotReadyForUpdate, "Please, commit and push your changes before updating config.")
      end
    end
  end
end
