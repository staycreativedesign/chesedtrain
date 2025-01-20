# == Schema Information
#
# Table name: selections
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  name         :string
#  quantity     :bigint           default(0)
#  special_note :string
#  placeholder  :string
#  potluck_id   :bigint
#  volunteer_id :bigint
#  bringing     :string
#
class Selection < ApplicationRecord
  belongs_to :potluck
  belongs_to :volunteer, class_name: "User", optional: true
  validates :name, :quantity, presence: true
end
