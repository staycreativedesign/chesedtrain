# == Schema Information
#
# Table name: selections
#
#  id              :bigint           not null, primary key
#  bringing        :string
#  name            :string
#  placeholder     :string
#  potluck_date    :datetime
#  quantity        :bigint           default(0)
#  special_note    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chesed_train_id :bigint
#  potluck_id      :bigint
#  volunteer_id    :bigint
#
# Indexes
#
#  index_selections_on_chesed_train_id  (chesed_train_id)
#  index_selections_on_potluck_id       (potluck_id)
#  index_selections_on_volunteer_id     (volunteer_id)
#
# Foreign Keys
#
#  fk_rails_...  (volunteer_id => users.id)
#
class Selection < ApplicationRecord
  belongs_to :event_date, optional: true
  belongs_to :potluck, optional: true
  belongs_to :volunteer, class_name: 'User', optional: true
  validates :name, :quantity, presence: true
end
