# == Schema Information
#
# Table name: volunteer_events
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_volunteer_events_on_event_id  (event_id)
#  index_volunteer_events_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class VolunteerEvent < ApplicationRecord
  belongs_to :event
  belongs_to :user
end
