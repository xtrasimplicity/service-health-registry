require 'spec_helper'

RSpec.describe ServiceHealthRegistry::Service do
  before do
    ServiceHealthRegistry::Service.destroy_all!
  end

  describe '.register' do
    let(:service_object) { ServiceHealthRegistry::Service.new('MyApp') }

    context 'when a service already exists with this name' do
      before do
        ServiceHealthRegistry::Service.register(service_object)
      end
      
      it 'raises a ServiceHealthRegistry::ServiceAlreadyExistsError' do
        expect { ServiceHealthRegistry::Service.register(service_object) }.to raise_error(ServiceHealthRegistry::ServiceAlreadyExistsError)
      end
    end

    context 'when a service does NOT exist with this name' do
      before do
        ServiceHealthRegistry::Service.register(service_object)
      end

      subject { ServiceHealthRegistry::Service[service_object.name] }

      it 'creates the service' do
        expect(subject).to eq(service_object)
      end

      it 'initialises the sensors' do
        expect(subject.sensors).to eq({})
      end
    end
  end

  describe '.[](service_name)' do
    let(:service) { ServiceHealthRegistry::Service.new('MyService') }

    context 'when a service exists with the supplied name' do
      before do
        ServiceHealthRegistry::Service.register(service)
      end

      it 'returns the service object' do
        expect(ServiceHealthRegistry::Service[service.name]).to eq(service)
      end
    end

    context 'when a service does NOT exist with the supplied name' do
      it 'raises a ServiceHealthRegistry::ServiceNotFoundError' do
        expect { ServiceHealthRegistry::Service['someNonExistantService'] }.to raise_error(ServiceHealthRegistry::ServiceNotFoundError)
      end
    end
  end

  describe '#new' do
    it 'stores the service name' do
      expected_name = 'MyService'

      subject = ServiceHealthRegistry::Service.new(expected_name)

      expect(subject.name).to eq(expected_name)
    end

    it 'defaults #sensors to an empty hash' do
      subject = ServiceHealthRegistry::Service.new('name')

      expect(subject.sensors).to eq({})
    end
  end

  describe '#[]' do
    context 'when a sensor exists with the supplied name' do
      it 'returns the sensor object'
    end

    context 'when a sensor does NOT exist with the supplied name' do
      it 'creates a sensor object'
    end
  end
end