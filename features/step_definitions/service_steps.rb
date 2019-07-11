Given("I have registered a service named {string}") do |name|
  payload = { name: name }

  RestClient.post("http://127.0.0.1:#{ServiceHealthRegistry::Server.port}/register_service", payload, {})
end

Given("there isn't a registered service named {string}") do |name|
  expect { ServiceHealthRegistry::Service[name] }.to raise_error(ServiceHealthRegistry::ServiceNotFoundError)
end