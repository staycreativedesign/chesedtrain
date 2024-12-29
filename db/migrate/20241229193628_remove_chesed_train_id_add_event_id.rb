class RemoveChesedTrainIdAddEventId < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_dates, :event, index: true, foreign_key: true
  end
end
