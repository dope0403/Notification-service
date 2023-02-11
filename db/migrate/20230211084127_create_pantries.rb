class CreatePantries < ActiveRecord::Migration[7.0]
  def change
    create_table :pantries do |t|
      t.integer :order_id
      t.integer :employee_id
      t.string :employee_name
      t.string :chef_name
      t.integer :duration

      t.timestamps
    end
  end
end
