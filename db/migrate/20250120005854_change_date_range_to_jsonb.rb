class ChangeDateRangeToJsonb < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :date_range, :datetime
    add_column :events, :date_range, :jsonb
  end
end
