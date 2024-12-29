class AddDefaultToUpdates < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :updates, from: nil, to: true
  end
end
