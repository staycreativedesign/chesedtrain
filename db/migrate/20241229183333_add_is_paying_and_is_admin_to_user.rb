class AddIsPayingAndIsAdminToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_paying, :boolean, default: false
    add_column :users, :is_admin, :boolean, default: false
  end
end
