class AddEmployeeEmailToEntry < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :employee_email, :string
  end
end
