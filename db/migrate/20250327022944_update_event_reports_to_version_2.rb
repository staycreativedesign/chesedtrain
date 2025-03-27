class UpdateEventReportsToVersion2 < ActiveRecord::Migration[7.2]
  def change
    update_view :event_reports, version: 2, revert_to_version: 1
  end
end
