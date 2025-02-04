class AddAreaCodesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :area_code, :string
  end
end
