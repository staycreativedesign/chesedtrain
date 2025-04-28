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
class Potluck < Event
  validates :preferred_time, :start_date, presence: true

  has_many :selections, dependent: :destroy

  accepts_nested_attributes_for :selections
  after_create :add_selections
  SELECTIONS = ['Appetizers', 'Salads', 'Side Dishes', 'Main Dishes', 'Beverages', 'Desserts'].freeze

  def add_selections
    SELECTIONS.each do |selection|
      selections.create(name: selection, quantity: 0, placeholder: selection, potluck_date: start_date)
    end
  end

  # normalizes :email_address, with: ->(e) { e.strip.downcase }
end
