# == Schema Information
#
# Table name: volunteer_events
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  event_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class VolunteerEvent < ApplicationRecord
  belongs_to :event
  belongs_to :user
end
