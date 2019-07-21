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
  end
end