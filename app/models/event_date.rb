# == Schema Information
#
# Table name: event_dates
#
#  id              :bigint           not null, primary key
#  bringing        :text
#  date_month      :string
#  date_number     :string
#  date_weekday    :string
#  full_date       :datetime
#  special_note    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chesed_train_id :bigint
#  volunteer_id    :bigint
#
# Indexes
#
#  index_event_dates_on_chesed_train_id  (chesed_train_id)
#  index_event_dates_on_volunteer_id     (volunteer_id)
#
# Foreign Keys
#
#  fk_rails_...  (volunteer_id => users.id)
#
class EventDate < ApplicationRecord
  belongs_to :chesed_train, class_name: 'Event'
  belongs_to :volunteer, class_name: 'User', optional: true
  has_many :selections, dependent: :destroy
  after_create :add_selections
  accepts_nested_attributes_for :selections
  SELECTIONS = ['Appetizers', 'Salads', 'Side Dishes', 'Main Dishes', 'Beverages', 'Desserts'].freeze

  def add_selections
    return unless %w[Friday Saturday].include?(date_weekday)

    SELECTIONS.each do |selection|
      selections.create(name: selection, quantity: 1, placeholder: selection, potluck_date: full_date)
    end
  end
end
