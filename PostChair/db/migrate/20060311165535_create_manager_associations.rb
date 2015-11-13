class CreateManagerAssociations < ActiveRecord::Migration
  def change
    create_table :manager_associations do |t|
      t.integer :manager_id
      t.integer :employee_id
      t.boolean :active

      t.timestamps null: false
    end
  end
end
