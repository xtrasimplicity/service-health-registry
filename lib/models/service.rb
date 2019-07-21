module ServiceHealthRegistry
  class Service < ActiveRecord::Base
    attr_reader :sensors

    validates :name, uniqueness: true, presence: true

    def initialize(name)
      attrs = {
        name: name,
        authentication_token: SecureRandom.hex(12)
      }

      super(attrs)
    end

    def register_sensor(sensor_name)
      raise ServiceHealthRegistry::SensorAlreadyExistsError.new("#{sensor_name} already exists") if sensors.has_key?(sensor_name)

      sensors[sensor_name] = ServiceHealthRegistry::Sensor.new(sensor_name)
    end
  
    def get_sensor(sensor_name)
      sensors[sensor_name] || register_sensor(sensor_name)
    end

    def destroy_sensors!
      sensors = {}
    end

    def sensors
      @sensors ||= {}
    end
  end
end