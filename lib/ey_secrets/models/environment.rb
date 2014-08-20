module EySecrets
  class Environment < Struct.new(:name, :instances)
    def initialize(*)
      super
      instances.each do |instance|
        instance.environment = self
      end
    end
  end
end
