class AddChesedTrainToEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_dates, :chesed_train, index: true, foreign_key: true
  end
end
