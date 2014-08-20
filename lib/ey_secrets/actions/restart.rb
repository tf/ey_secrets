module EySecrets
  class Restart < Struct.new(:instance, :options)
    include CommandBuilder

    def build
      restart_monit
      restart_passenger
    end

    private

    def restart_monit
      ssh("sudo monit restart -g #{instance.app_name}_resque")
    end

    def restart_passenger
      ssh("if [ -d #{File.join(instance.current_app_dir, 'tmp')} ]; then touch #{File.join(instance.current_app_dir, 'tmp', 'restart.txt')}; fi")
    end
  end
end
