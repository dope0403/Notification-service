class AddRoomToMeeting < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :room, :string
  end
end
