module ServiceHealthRegistry
  module ServiceRepository

    def self.find(service_name)
      raise ServiceHealthRegistry::ServiceNotFoundError.new("#{service_name} does not exist") unless service_exists?(service_name)

      Service.find_by(name: service_name)
    end

    def self.register(service)
      raise ServiceHealthRegistry::ServiceAlreadyExistsError.new("#{service.name} already exists") if service_exists?(service.name)

      service.save!
    end

    def self.destroy_all!
      Service.destroy_all
    end

    private

    def self.service_exists?(service_name)
      !Service.find_by(name: service_name).nil?
    end
  end
end