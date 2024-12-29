class AddFavoriteRestaurantToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :fav_rest, :string
  end
end
