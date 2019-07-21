class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.string :authentication_token, null: false
    end

    add_index :services, :name, unique: true
  end
end
