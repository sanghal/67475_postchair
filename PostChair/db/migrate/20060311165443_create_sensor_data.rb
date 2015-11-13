class CreateSensorData < ActiveRecord::Migration
  def change
    create_table :sensor_data do |t|
      t.references :user_id, index: true, foreign_key: true
      t.integer :position
      t.datetime :time
      t.integer :measurement

      t.timestamps null: false
    end
  end
end
