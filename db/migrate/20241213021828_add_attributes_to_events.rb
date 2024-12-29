class AddAttributesToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :recipent_email, :string
    add_column :events, :recipent_name, :string
    add_column :events, :address1, :string
    add_column :events, :address2, :string
    add_column :events, :city, :string
    add_column :events, :state, :string
    add_column :events, :adults, :integer
    add_column :events, :kids, :integer
    add_column :events, :allergies, :string
    add_column :events, :preferred_time, :string
    add_column :events, :dietary_restrictions, :string
    add_column :events, :special_message, :text
    add_column :events, :stage, :integer
    add_reference :events, :owner, foreign_key: { to_table: :users }
  end
end
