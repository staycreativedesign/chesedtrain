class AddFullDateToEventDates < ActiveRecord::Migration[7.0]
  def change
    add_column :event_dates, :full_date, :datetime
  end
end
