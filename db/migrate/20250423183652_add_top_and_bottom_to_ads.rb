class AddTopAndBottomToAds < ActiveRecord::Migration[7.2]
  def change
      add_column :ads, :location, :string, default: 'top'
  end
end
