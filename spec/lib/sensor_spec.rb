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

  describe '#healthy?' do
    it 'returns false if the sensor is not healthy' do
      subject.set_health_status!(false)

      expect(subject.healthy?).to eq(false)
    end

    it 'returns false if the heartbeat has expired' do
      subject.set_health_status!(true)
      expect(subject).to receive(:has_heartbeat_expired?).and_return(true)

      expect(subject.healthy?).to eq(false)
    end

    it 'returns true if the sensor is healthy and the heartbeat has NOT expired' do
      subject.set_health_status!(true)
      expect(subject).to receive(:has_heartbeat_expired?).and_return(false)

      expect(subject.healthy?).to eq(true)
    end
  end

  describe '#has_heartbeat_expired?' do
    describe 'if a heartbeat interval has been configured' do
      let(:interval) { 10.seconds }

      before do
        subject.set_heartbeat_interval! interval.to_i

        subject.set_health_status!(true)
        subject.reload
      end

      it 'returns true if the last update was more than {HEARTBEAT_INTERVAL} seconds ago' do
        expect(DateTime).to receive(:now).and_return(subject.last_updated_at + (interval + 1.second))

        expect(subject.has_heartbeat_expired?).to eq(true)
      end

      it 'returns false if the last update was less than {HEARTBEAT_INTERVAL} seconds ago' do
        expect(DateTime).to receive(:now).and_return(subject.last_updated_at + (interval - 1.second))

        expect(subject.has_heartbeat_expired?).to eq(false)
      end

      it 'returns false if the sensor has never been updated' do
        expect(subject).to receive(:last_updated_at).and_return(nil)

        expect(subject.has_heartbeat_expired?).to eq(false)
      end
    end

    describe 'if a heartbeat interval has NOT been configured' do
      before do
        subject.set_heartbeat_interval! nil
      end

      it 'returns false' do
        expect(subject.has_heartbeat_expired?).to eq(false)
      end
    end
  end

  describe '#set_heartbeat_interval!' do
    it 'sets the interval' do
      expect(subject.heartbeat_interval).to eq(nil)

      subject.set_heartbeat_interval! 20

      expect(subject.heartbeat_interval).to eq(20)
    end
  end
end