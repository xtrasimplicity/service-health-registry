class CreateSensors < ActiveRecord::Migration[5.2]
  def change
    create_table :sensors do |t|
      t.references :service
      t.string :name, null: false
      t.boolean :healthy, default: false
      t.datetime :last_updated_at
    end

    add_index :sensors, [:service_id, :name], unique: true
  end
end
