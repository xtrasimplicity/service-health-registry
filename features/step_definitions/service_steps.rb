Given("I have registered a service named {string}") do |name|
  payload = { name: name }

  @http_headers ||= {}

  @http_request = post_request('/register_service', payload, @http_headers)
end

Given("there isn't a registered service named {string}") do |name|
  expect { ServiceHealthRegistry::Service[name] }.to raise_error(ServiceHealthRegistry::ServiceNotFoundError)
end

Given("the admin authentication token is {string}") do |token|
  ServiceHealthRegistry::Server.settings.admin_authentication_token = token
end