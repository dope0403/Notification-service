class AddTestToPantry < ActiveRecord::Migration[7.0]
  def change
    add_column :pantries, :test, :string
  end
end
