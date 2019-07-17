require 'cucumber/rspec/doubles'

Before '@stub-service-registration-auth-token' do
  allow_any_instance_of(ServiceHealthRegistry::Service).to receive(:authentication_token).and_return('MySecretServiceSpecificToken')
end