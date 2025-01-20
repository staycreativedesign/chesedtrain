# == Schema Information
#
# Table name: event_dates
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  date_number     :string
#  date_weekday    :string
#  date_month      :string
#  chesed_train_id :bigint
#  special_note    :string
#  volunteer_id    :bigint
#  bringing        :text
#  full_date       :datetime
#
class EventDate < ApplicationRecord
  belongs_to :chesed_train, class_name: 'Event'
  belongs_to :volunteer, class_name: 'User', optional: true
end
