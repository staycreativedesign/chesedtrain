class DropChesedTrainsAndPotlucks < ActiveRecord::Migration[7.0]
  def change
    drop_table :chesed_trains
    drop_table :potlucks
  end
end
