class CreateEventDates < ActiveRecord::Migration[7.0]
  def change
    create_table :event_dates do |t|
      t.belongs_to :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
