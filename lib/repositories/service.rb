module ServiceHealthRegistry
  module ServiceRepository
    @@services = {}

    def self.find(service_name)
      raise ServiceHealthRegistry::ServiceNotFoundError.new("#{service_name} does not exist") unless @@services.has_key? service_name

        @@services[service_name]
    end

    def self.register(service)
      raise ServiceHealthRegistry::ServiceAlreadyExistsError.new("#{service.name} already exists") if @@services.has_key? service.name

        @@services[service.name] = service
    end

    def self.destroy_all!
      @@services = {}
    end
  end
end