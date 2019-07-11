module ServiceHealthRegistry
  class ServiceNotFoundError < StandardError; end
  class ServiceAlreadyExistsError < StandardError; end
end