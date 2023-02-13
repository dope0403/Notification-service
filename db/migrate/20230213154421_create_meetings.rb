class CreateMeetings < ActiveRecord::Migration[7.0]
  def change
    create_table :meetings do |t|
      t.integer :meeting_id
      t.integer :employee_id
      t.string :room
      t.timestamp :time
      t.integer :status
      t.string :employee_email

      t.timestamps
    end
  end
end
