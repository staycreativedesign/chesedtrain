class PostalCode < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :postal_code, :string
  end
end
