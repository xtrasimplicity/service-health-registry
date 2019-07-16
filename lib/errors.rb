module ServiceHealthRegistry
  class ServiceNotFoundError < StandardError; end
  class ServiceAlreadyExistsError < StandardError; end
  class SensorAlreadyExistsError < StandardError; end
end