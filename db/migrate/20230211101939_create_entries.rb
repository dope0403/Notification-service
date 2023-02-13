class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.integer :employee_id
      t.string :message
      t.integer :type

      t.timestamps
    end
  end
end
