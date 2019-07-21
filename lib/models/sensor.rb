module ServiceHealthRegistry
  class Sensor
    attr_reader :name, :last_updated_at
    
    def initialize(name)
      @name = name
      @healthy = false
    end

    def set_health_status(healthy)
      @healthy = healthy
      @last_updated_at = DateTime.now
    end

    def healthy?
      @healthy
    end

    def has_received_data?
      !@last_updated_at.nil?
    end
  end
end