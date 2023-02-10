class AddTimeToMeeting < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :time, :timestamp
  end
end
