class AddSpecialNoteToEventDate < ActiveRecord::Migration[7.0]
  def change
    add_column :event_dates, :special_note, :string
  end
end
