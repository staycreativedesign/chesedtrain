# == Schema Information
#
# Table name: user_reports
#
#  full_name          :text
#  email_address      :string
#  contact_number     :text
#  pro                :boolean
#  sms                :boolean
#  created_at         :datetime
#  country_name       :text
#  event_created      :bigint
#  volunteered_events :bigint
#
class UserReports < ApplicationRecord
  def readonly?
    true
  end
end
