class CreateUpdates < ActiveRecord::Migration[7.0]
  def change
    create_table :updates do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
