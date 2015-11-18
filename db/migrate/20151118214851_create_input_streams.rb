class CreateInputStreams < ActiveRecord::Migration
  def change
    create_table :input_streams do |t|
      t.integer :user_id
      t.integer :position
      t.date :input_time
      t.integer :measurement

      t.timestamps null: false
    end
  end
end
