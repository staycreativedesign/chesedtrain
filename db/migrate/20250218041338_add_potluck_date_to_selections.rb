class AddPotluckDateToSelections < ActiveRecord::Migration[7.0]
  def change
    add_column :selections, :potluck_date, :datetime
  end
end
