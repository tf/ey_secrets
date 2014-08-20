require 'rainbow'

module EySecrets
  class Shell
    class CommandFailed < Error
    end

    def self.execute!(action, options = {})
      action.commands.each do |command|
        yield(command) if block_given?
        return if options[:dry_run]

        unless system(command)
          raise(CommandFailed, "Error while executing #{command}")
        end
      end
    end
  end
end
