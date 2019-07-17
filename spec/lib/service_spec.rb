require 'spec_helper'

RSpec.describe ServiceHealthRegistry::Service do
  subject { ServiceHealthRegistry::Service.new('myService') }

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
      let(:stubbed_auth_token) { SecureRandom.hex(12) }

      before do
        expect(SecureRandom).to receive(:hex).with(12).and_return(stubbed_auth_token)

        ServiceHealthRegistry::Service.register(service_object)
      end

      subject { ServiceHealthRegistry::Service.find(service_object.name) }

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
        ServiceHealthRegistry::Service.register(service)
      end

      it 'returns the service object' do
        expect(ServiceHealthRegistry::Service.find(service.name)).to eq(service)
      end
    end

    context 'when a service does NOT exist with the supplied name' do
      it 'raises a ServiceHealthRegistry::ServiceNotFoundError' do
        expect { ServiceHealthRegistry::Service.find('someNonExistantService') }.to raise_error(ServiceHealthRegistry::ServiceNotFoundError)
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

  describe '#register_sensor' do
    let(:sensor_name) { 'NewSensor' }

    context 'when a sensor with this name already exists' do
      before do
        subject.register_sensor(sensor_name)
      end

      it 'raises an error' do
        expect { subject.register_sensor(sensor_name) }.to raise_error(ServiceHealthRegistry::SensorAlreadyExistsError)
      end
    end

    context 'when a sensor does not exist with this name' do
      before do
        subject.destroy_sensors!
      end

      it 'registers the sensor' do
        subject.register_sensor(sensor_name)

        expect(subject.sensors.length).to eq(1)
        actual_sensor = subject.get_sensor(sensor_name)

        expect(actual_sensor).to be_a_kind_of(ServiceHealthRegistry::Sensor)
        expect(actual_sensor.name).to eq(sensor_name)
      end
    end
  end

  describe '#get_sensor' do
    let(:sensor) { ServiceHealthRegistry::Sensor.new('myNewSensor').tap { |s| s.set_health_status(true) } }

    context 'when a sensor exists with the supplied name' do
      before do
        subject.register_sensor(sensor.name)
        subject.get_sensor(sensor.name).set_health_status(sensor.healthy?)
      end

      it 'returns the sensor object' do
        actual_sensor = subject.get_sensor(sensor.name)

        expect(actual_sensor.name).to eq(sensor.name)
        expect(actual_sensor.healthy?).to eq(sensor.healthy?)
      end
    end

    context 'when a sensor does NOT exist with the supplied name' do
      it 'creates a sensor object' do
        actual_sensor = subject.get_sensor(sensor.name)

        expect(actual_sensor.name).to eq(sensor.name)
        expect(actual_sensor.healthy?).to eq(false)
      end
    end
  end
end