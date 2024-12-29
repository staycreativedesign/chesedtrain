class AddBringingToEventDate < ActiveRecord::Migration[7.0]
  def change
    add_column :event_dates, :bringing, :text
  end
end
