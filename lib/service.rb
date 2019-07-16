module ServiceHealthRegistry
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
  end
end