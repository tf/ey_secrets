module EySecrets
  module CompositeCommandBuilder
    def action(action)
      @actions << action
    end

    def commands
      @actions = []
      build
      @actions.map(&:commands).flatten
    end
  end
end
