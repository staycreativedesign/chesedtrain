class CreatePotlucks < ActiveRecord::Migration[7.0]
  def change
    create_table :potlucks do |t|
      t.timestamps
    end
  end
end
