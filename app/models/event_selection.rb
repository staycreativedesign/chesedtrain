# == Schema Information
#
# Table name: event_selections
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  selection_id :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_event_selections_on_selection_id  (selection_id)
#  index_event_selections_on_user_id       (user_id)
#
class EventSelection < ApplicationRecord
  belongs_to :selection
  belongs_to :user
end
