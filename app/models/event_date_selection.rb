# == Schema Information
#
# Table name: event_date_selections
#
#  id            :bigint           not null, primary key
#  food          :string
#  message       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  event_date_id :bigint
#  event_id      :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_event_date_selections_on_event_date_id  (event_date_id)
#  index_event_date_selections_on_event_id       (event_id)
#  index_event_date_selections_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class EventDateSelection < ApplicationRecord
  belongs_to :event_date
  belongs_to :event
end
