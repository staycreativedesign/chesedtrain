class AddShabbatToChesedTrain < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :shabbat_instructions, :string
  end
end
