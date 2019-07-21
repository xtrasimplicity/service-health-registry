module ServiceHealthRegistry
  class Service
    attr_reader :name, :sensors, :authentication_token

    def initialize(name)
      @name = name
      @sensors = {}
      @authentication_token = SecureRandom.hex(12)
    end

    def register_sensor(sensor_name)
      raise ServiceHealthRegistry::SensorAlreadyExistsError.new("#{sensor_name} already exists") if @sensors.has_key?(sensor_name)

      @sensors[sensor_name] = ServiceHealthRegistry::Sensor.new(sensor_name)
    end
  
    def get_sensor(sensor_name)
      @sensors[sensor_name] || register_sensor(sensor_name)
    end

    def destroy_sensors!
      @sensors = {}
    end
  end
end