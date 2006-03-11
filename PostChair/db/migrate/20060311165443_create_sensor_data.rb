class CreateSensorData < ActiveRecord::Migration
  def change
    create_table :sensor_data do |t|
      t.references :user_id, index: true, foreign_key: true
      t.int :position
      t.datetime :time
      t.int :measurement

      t.timestamps null: false
    end
  end
end
