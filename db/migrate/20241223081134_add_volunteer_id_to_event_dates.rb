class AddVolunteerIdToEventDates < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_dates, :volunteer, foreign_key: { to_table: :users }
  end
end
