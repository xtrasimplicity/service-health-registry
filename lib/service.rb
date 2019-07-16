module ServiceHealthRegistry
  require_relative 'sensor'

  class Service
    class << self
      @@services = {}
      
      def find(service_name)
        raise ServiceHealthRegistry::ServiceNotFoundError.new("#{service_name} does not exist") unless @@services.has_key? service_name

        @@services[service_name]
      end

      def register(service)
        raise ServiceHealthRegistry::ServiceAlreadyExistsError.new("#{service.name} already exists") if @@services.has_key? service.name

        @@services[service.name] = service
      end

      def destroy_all!
        @@services = {}
      end
    end

    attr_reader :name, :sensors

    def initialize(name)
      @name = name
      @sensors = {}
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