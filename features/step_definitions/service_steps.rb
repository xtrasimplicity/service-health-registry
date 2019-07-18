Given("I have registered a service named {string}") do |name|
  @service = ServiceHealthRegistry::Service.new(name)

  ServiceHealthRegistry::Service.register(@service)
end

Given("there isn't a registered service named {string}") do |name|
  expect { ServiceHealthRegistry::Service.find(name) }.to raise_error(ServiceHealthRegistry::ServiceNotFoundError)
end

Given("the admin authentication token is {string}") do |token|
  ServiceHealthRegistry::Server.settings.admin_authentication_token = token
end