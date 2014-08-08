require 'rainbow'

module EySecrets
  class Instance
    attr_reader :hostname, :username, :app_name

    def initialize(hostname, username, app_name)
      @hostname = hostname
      @username = username
      @app_name = app_name
    end

    def ensure_config_dir!
      ssh "if [ ! -d #{config_dir} ]; then mkdir -p #{config_dir}; fi"
    end

    def sync(files)
      files.each do |file|
        scp file, File.join(config_dir, File.basename(file))
      end
    end

    def restart
      ssh "sudo monit restart -g #{app_name}_resque"
      ssh "if [ -d #{File.join app_dir, 'tmp'} ]; then touch #{File.join app_dir, 'tmp', 'restart.txt'}; fi"
    end

    private

    def ssh(cmd)
      log "Executing: #{cmd}"

      unless exec("ssh #{username}@#{hostname} \"#{cmd}\"")
        raise "Error while executing #{cmd} on #{hostname}"
      end
    end

    def scp(from, to)
      log "scp #{from} #{to}"

      unless exec("scp #{from} #{target_for(to)}")
        raise "Error while copying #{from} to #{target_for(to)}"
      end
    end

    def target_for(file)
      "#{username}@#{hostname}:#{file}"
    end

    def config_dir
      "/data/#{app_name}/shared/config"
    end

    def app_dir
      "/data/#{app_name}/current/"
    end

    def exec(cmd)
      system cmd
    end

    def log(msg)
      puts Rainbow(msg).green
    end
  end
end
