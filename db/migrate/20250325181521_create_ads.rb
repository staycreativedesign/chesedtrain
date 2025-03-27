class CreateAds < ActiveRecord::Migration[7.2]
  def change
    create_table :ads do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :views, default: 0
      t.integer :clicks, default: 0
      t.string :zipcode
      t.string :country
      t.string :link
      t.timestamps
    end
  end
end
