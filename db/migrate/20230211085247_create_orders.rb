class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :employee_id
      t.string :employee_name
      t.integer :order_id
      t.integer :duration
      t.string :chef_name

      t.timestamps
    end
  end
end
