class AddWhatToBringToSelection < ActiveRecord::Migration[7.0]
  def change
    add_column :selections, :bringing, :string
  end
end
