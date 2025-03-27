class CreateEventReports < ActiveRecord::Migration[7.2]
  def change
    create_view :event_reports
  end
end
