module EySecrets
  module CommandBuilder
    def scp(source, destination)
      @commands << "scp #{source} #{instance.user_name}@#{instance.host_name}:#{destination}"
    end

    def ssh(command)
      @commands << "ssh #{instance.user_name}@#{instance.host_name} \"#{command}\""
    end

    def commands
      @commands = []
      build
      @commands
    end

    private

    def build
      raise(NotImplementedError)
    end
  end
end
