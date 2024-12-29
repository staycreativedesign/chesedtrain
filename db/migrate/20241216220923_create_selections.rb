class CreateSelections < ActiveRecord::Migration[7.0]
  def change
    create_table :selections do |t|
      t.timestamps
    t.string :name
    t.bigint :quantity, default: 0
    t.string :special_note
    t.string :placeholder
    t.belongs_to :potluck
    t.belongs_to :volunteer, foreign_key: { to_table: :users }
    end
  end
end
