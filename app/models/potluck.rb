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
class Potluck < Event
  validates :preferred_time, :start_date, presence: true

  has_many :selections
  accepts_nested_attributes_for :selections
  after_create :add_selections
  SELECTIONS = ['Appetizers', 'Salads', 'Side Dishes', 'Main Dishes', 'Beverages', 'Desserts'].freeze

  def add_selections
    SELECTIONS.each do |selection|
      selections.create(name: selection, quantity: 0, placeholder: selection)
    end
  end

  # normalizes :email_address, with: ->(e) { e.strip.downcase }
end
