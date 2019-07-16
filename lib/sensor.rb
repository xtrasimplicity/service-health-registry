module ServiceHealthRegistry
  class Sensor
    attr_reader :name
    
    def initialize(name)
      @name = name
      @healthy = false
    end

    def set_health_status(healthy)
      @healthy = healthy
    end

    def healthy?
      @healthy
    end
  end
end