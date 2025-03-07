class AddTokeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :toke, :string, default: SecureRandom.hex(10)
  end
end
