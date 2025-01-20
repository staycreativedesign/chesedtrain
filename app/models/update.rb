# == Schema Information
#
# Table name: updates
#
#  id         :bigint           not null, primary key
#  event_id   :bigint           not null
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Update < ApplicationRecord
  belongs_to :event
end
