class AddHeartbeatIntervalToSensor < ActiveRecord::Migration[5.2]
  def change
    add_column :sensors, :heartbeat_interval, :int, null: true
  end
end
