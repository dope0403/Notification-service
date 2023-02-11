class AddEmployeeEmailToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :employee_email, :string
  end
end
