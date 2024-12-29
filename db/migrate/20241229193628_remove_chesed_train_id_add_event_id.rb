class RemoveChesedTrainIdAddEventId < ActiveRecord::Migration[7.0]
  def change
    remove_column :event_dates, :chesed_train, index: true, foreign_key: true
    add_reference :event_dates, :event, index: true, foreign_key: true
  end
end
