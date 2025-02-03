# == Schema Information
#
# Table name: events
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  start_date           :datetime
#  end_date             :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  recipent_email       :string
#  recipent_name        :string
#  address1             :string
#  address2             :string
#  city                 :string
#  state                :string
#  adults               :integer
#  kids                 :integer
#  allergies            :string
#  preferred_time       :string
#  dietary_restrictions :string
#  special_message      :text
#  owner_id             :bigint
#  type                 :string
#  least                :string
#  shabbat_instructions :string
#  fav_rest             :string
#  step                 :integer
#  country              :string
#  postal_code          :string
#  status               :integer          default("opened"), not null
#  date_range           :jsonb
#
class ChesedTrain < Event
  validates :recipent_email, :recipent_name, presence: true
  has_many :event_dates, foreign_key: :chesed_train_id, dependent: :destroy
  accepts_nested_attributes_for :event_dates

  serialize :date_range, Hash
end
