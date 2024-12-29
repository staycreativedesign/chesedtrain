# == Schema Information
#
# Table name: events
#
#  id                   :bigint           not null, primary key
#  address1             :string
#  address2             :string
#  adults               :integer
#  allergies            :string
#  city                 :string
#  date_range           :datetime
#  dietary_restrictions :string
#  end_date             :datetime
#  fav_rest             :string
#  kids                 :integer
#  least                :string
#  name                 :string
#  preferred_time       :string
#  recipent_email       :string
#  recipent_name        :string
#  shabbat_instructions :string
#  special_message      :text
#  start_date           :datetime
#  state                :string
#  step                 :integer
#  type                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  owner_id             :bigint
#
# Indexes
#
#  index_events_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Event < ApplicationRecord
  has_many :volunteers
  belongs_to :owner, class_name: "User"
  #
  has_many :volunteer_events
  has_many :volunteers, through: :volunteer_events, source: :user

  validates :name, presence: true
end
