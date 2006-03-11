class CreateManagerAssociations < ActiveRecord::Migration
  def change
    create_table :manager_associations do |t|
      t.int :manager_id
      t.int :employee_id
      t.boolean :active

      t.timestamps null: false
    end
  end
end
