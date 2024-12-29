class CreateChesedTrains < ActiveRecord::Migration[7.0]
  def change
    create_table :chesed_trains do |t|
      t.timestamps
    end
  end
end
