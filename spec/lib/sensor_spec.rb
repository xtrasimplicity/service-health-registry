require 'spec_helper'

RSpec.describe ServiceHealthRegistry::Sensor do
  subject { ServiceHealthRegistry::Sensor.new('sensor_name') }

  describe '#new' do
    it 'stores the supplied name'
  end

  describe '#set_health_status!' do
    it 'updates the status' do
      [true, false].each do |val|
        subject.set_health_status!(val)
        expect(subject.healthy?).to eq(val)
      end
    end

    it 'updates the `last_updated` timestamp' do
      stubbed_time = DateTime.now
      expect(DateTime).to receive(:now).and_return(stubbed_time)
      expect(subject.last_updated_at).to be_nil

      subject.set_health_status!(false)

      expect(subject.last_updated_at.strftime("%Y%m%d %H%m")).to eq(stubbed_time.utc.strftime("%Y%m%d %H%m"))
    end
  end

  describe '#has_received_data?' do
    it 'returns false if the sensor has not received data' do
      expect(subject.has_received_data?).to eq(false)
    end

    it 'returns true if the sensor has received data' do
      subject.set_health_status!(true)
      
      expect(subject.has_received_data?).to eq(true)
    end
  end
end