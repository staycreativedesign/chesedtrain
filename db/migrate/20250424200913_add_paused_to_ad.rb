class AddPausedToAd < ActiveRecord::Migration[7.2]
  def change
    add_column :ads, :paused, :boolean, default: false
  end
end
