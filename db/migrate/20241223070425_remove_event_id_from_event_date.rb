class RemoveEventIdFromEventDate < ActiveRecord::Migration[7.0]
  def change
    remove_column :event_dates, :event_id, :bigint
  end
end
