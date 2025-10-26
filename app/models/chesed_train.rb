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
#  slug                 :string
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
#  index_events_on_slug      (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class ChesedTrain < Event
  extend FriendlyId

  validates :recipent_email, :recipent_name, presence: true
  has_many :event_dates, foreign_key: :chesed_train_id, dependent: :destroy
  accepts_nested_attributes_for :event_dates

  # serialize :date_range, Hash
end
