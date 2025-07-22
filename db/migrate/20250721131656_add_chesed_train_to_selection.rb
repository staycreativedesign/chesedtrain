class AddChesedTrainToSelection < ActiveRecord::Migration[7.2]
  def change
    add_reference :selections, :event_date
  end
end
