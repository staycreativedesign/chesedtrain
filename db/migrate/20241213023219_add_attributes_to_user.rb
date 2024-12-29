class AddAttributesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :updates, :boolean, default: true
    add_column :users, :tos, :boolean, default: true
    add_column :users, :sms, :boolean, default: true
    add_column :users, :guest, :boolean, default: false
  end
end
