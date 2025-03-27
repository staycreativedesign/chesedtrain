class CreateUserReports < ActiveRecord::Migration[7.2]
  def change
    create_view :user_reports
  end
end
