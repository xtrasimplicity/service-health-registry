require 'spec_helper'

RSpec.describe ServiceHealthRegistry::Service do
  describe '.[]' do
    context 'when a service exists with the supplied name' do
      it 'returns the service object'
    end

    context 'when a service does NOT exist with the supplied name' do
      it 'creates a new service object'
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