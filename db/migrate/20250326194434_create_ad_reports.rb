class CreateAdReports < ActiveRecord::Migration[7.2]
  def change
    create_view :ad_reports
  end
end
