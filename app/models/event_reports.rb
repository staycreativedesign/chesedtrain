# == Schema Information
#
# Table name: event_reports
#
#  event_name      :string
#  event_type      :string
#  owner           :text
#  Email Address   :string
#  contact_number  :text
#  start_date      :datetime
#  end_date        :datetime
#  recipient_email :string
#  recipient_name  :string
#  country         :string
#  postal_code     :string
#  state           :string
#  created_at      :datetime
#  volunteer_count :bigint
#
class EventReports < ApplicationRecord
  def readonly?
    true
  end
end
