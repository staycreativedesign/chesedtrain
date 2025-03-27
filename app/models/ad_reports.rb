# == Schema Information
#
# Table name: ad_reports
#
#  id           :bigint
#  name         :string
#  start_date   :datetime
#  end_date     :datetime
#  views        :integer
#  clicks       :integer
#  zipcode      :string
#  country      :string
#  link         :string
#  created_at   :datetime
#  updated_at   :datetime
#  country_name :text
#
class AdReports < ApplicationRecord
  def readonly?
    true
  end
end
