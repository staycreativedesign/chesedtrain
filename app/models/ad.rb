# == Schema Information
#
# Table name: ads
#
#  id         :bigint           not null, primary key
#  name       :string
#  start_date :datetime
#  end_date   :datetime
#  views      :integer          default(0)
#  clicks     :integer          default(0)
#  zipcode    :string
#  country    :string
#  link       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Ad < ApplicationRecord
  include RandomAdSelector
  has_one_attached :image
end
