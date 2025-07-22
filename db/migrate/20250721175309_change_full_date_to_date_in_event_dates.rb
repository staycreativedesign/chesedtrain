class ChangeFullDateToDateInEventDates < ActiveRecord::Migration[7.2]
  def change
    change_column :event_dates, :full_date, :date
  end
end
