# == Schema Information
#
# Table name: sessions
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  ip_address :string
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Session < ApplicationRecord
  belongs_to :user
end
