module ServiceHealthRegistry
  class Service
    attr_reader :name, :sensors

    def initialize(name)
      @name = name
      @sensors = {}
    end
  end
end