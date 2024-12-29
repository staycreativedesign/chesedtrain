# == Schema Information
#
# Table name: selections
#
#  id           :bigint           not null, primary key
#  bringing     :string
#  name         :string
#  placeholder  :string
#  quantity     :bigint           default(0)
#  special_note :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  potluck_id   :bigint
#  volunteer_id :bigint
#
# Indexes
#
#  index_selections_on_potluck_id    (potluck_id)
#  index_selections_on_volunteer_id  (volunteer_id)
#
# Foreign Keys
#
#  fk_rails_...  (volunteer_id => users.id)
#
class Selection < ApplicationRecord
  belongs_to :potluck
  belongs_to :volunteer, class_name: "User", optional: true
  validates :name, :quantity, presence: true
end
