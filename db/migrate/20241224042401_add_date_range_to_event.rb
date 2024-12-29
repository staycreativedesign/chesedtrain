class AddDateRangeToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :date_range, :datetime
  end
end
