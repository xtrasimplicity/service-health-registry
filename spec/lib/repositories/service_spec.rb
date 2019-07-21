require 'spec_helper'

RSpec.describe ServiceHealthRegistry::ServiceRepository do
  before do
    ServiceHealthRegistry::ServiceRepository.destroy_all!
  end

  describe '.register' do
    let(:service_object) { ServiceHealthRegistry::Service.new('MyApp') }

    context 'when a service already exists with this name' do
      before do
        ServiceHealthRegistry::ServiceRepository.register(service_object)
      end
      
      it 'raises a ServiceHealthRegistry::ServiceAlreadyExistsError' do
        expect { ServiceHealthRegistry::ServiceRepository.register(service_object) }.to raise_error(ServiceHealthRegistry::ServiceAlreadyExistsError)
      end
    end

    context 'when a service does NOT exist with this name' do
      let(:stubbed_auth_token) { SecureRandom.hex(12) }

      before do
        expect(SecureRandom).to receive(:hex).with(12).and_return(stubbed_auth_token)

        ServiceHealthRegistry::ServiceRepository.register(service_object)
      end

      subject { ServiceHealthRegistry::ServiceRepository.find(service_object.name) }

      it 'creates the service' do
        expect(subject).to eq(service_object)
      end

      it 'initialises the sensors' do
        expect(subject.sensors).to eq({})
      end

      it 'generates an authentication token for this service' do
        expect(subject.authentication_token).to eq(stubbed_auth_token)
      end
    end
  end

  describe '.find(service_name)' do
    let(:service) { ServiceHealthRegistry::Service.new('MyService') }

    context 'when a service exists with the supplied name' do
      before do
        ServiceHealthRegistry::ServiceRepository.register(service)
      end

      it 'returns the service object' do
        expect(ServiceHealthRegistry::ServiceRepository.find(service.name)).to eq(service)
      end
    end

    context 'when a service does NOT exist with the supplied name' do
      it 'raises a ServiceHealthRegistry::ServiceNotFoundError' do
        expect { ServiceHealthRegistry::ServiceRepository.find('someNonExistantService') }.to raise_error(ServiceHealthRegistry::ServiceNotFoundError)
      end
    end
  end
end