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
#  country              :string
#  date_range           :jsonb
#  dietary_restrictions :string
#  end_date             :datetime
#  fav_rest             :string
#  kids                 :integer
#  least                :string
#  name                 :string
#  postal_code          :string
#  preferred_time       :string
#  recipent_email       :string
#  recipent_name        :string
#  shabbat_instructions :string
#  special_message      :text
#  start_date           :datetime
#  state                :string
#  status               :integer          default("opened"), not null
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
  enum :status, { opened: 0, closed: 1 }

  belongs_to :owner, class_name: 'User'
  has_many :volunteer_events, dependent: :destroy
  has_many :volunteers, through: :volunteer_events, source: :user

  validates :name, presence: true
end
