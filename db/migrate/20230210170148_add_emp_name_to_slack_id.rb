class AddEmpNameToSlackId < ActiveRecord::Migration[7.0]
  def change
    add_column :slack_ids, :emp_name, :string
  end
end
