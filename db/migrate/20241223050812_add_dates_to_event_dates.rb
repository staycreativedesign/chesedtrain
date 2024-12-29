class AddDatesToEventDates < ActiveRecord::Migration[7.0]
  def change
    add_column :event_dates, :date_number, :string
    add_column :event_dates, :date_weekday, :string
    add_column :event_dates, :date_month, :string
  end
end
