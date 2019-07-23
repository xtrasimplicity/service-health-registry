module ServiceHealthRegistry
  class Sensor < ActiveRecord::Base
    def initialize(name)
      attrs = {
        name: name,
        healthy: false
      }

      super(attrs)
    end

    def set_health_status!(healthy)
      update_attributes!(healthy: healthy, last_updated_at: DateTime.now)
    end

    def has_received_data?
      !last_updated_at.nil?
    end

    def healthy?
      return false unless healthy

      !has_heartbeat_expired?
    end

    def set_heartbeat_interval!(interval)
      update_attributes!(heartbeat_interval: interval)
    end

    def has_heartbeat_expired?
      return false unless heartbeat_interval && last_updated_at

      heartbeat_interval && !has_received_data_in_last?(heartbeat_interval.seconds)
    end

    private

    def has_received_data_in_last?(interval)
      DateTime.now <= (last_updated_at + interval)
    end
  end
end