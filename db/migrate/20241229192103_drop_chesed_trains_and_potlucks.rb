class DropChesedTrainsAndPotlucks < ActiveRecord::Migration[7.0]
  def change
    drop_table :chesed_trains, force: :cascade
    drop_table :potlucks, force: :cascade
  end
end
