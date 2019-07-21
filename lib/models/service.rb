module ServiceHealthRegistry
  class Service < ActiveRecord::Base
    has_many :sensors

    validates :name, uniqueness: true, presence: true

    def initialize(name)
      attrs = {
        name: name,
        authentication_token: SecureRandom.hex(12)
      }

      super(attrs)
    end

    def register_sensor(sensor_name)
      raise ServiceHealthRegistry::SensorAlreadyExistsError.new("#{sensor_name} already exists") if sensor_exists?(sensor_name)

      sensors << ServiceHealthRegistry::Sensor.new(sensor_name)
    end
  
    def get_sensor(sensor_name)
      register_sensor(sensor_name) unless sensor_exists?(sensor_name)

      sensors.find_by(name: sensor_name)
    end

    def destroy_sensors!
      sensors.destroy_all
    end

    private

    def sensor_exists?(sensor_name)
      sensors.where(name: sensor_name).length > 0
    end
  end
end