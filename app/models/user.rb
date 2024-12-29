# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email_address   :string           not null
#  first_name      :string
#  guest           :boolean          default(FALSE)
#  last_name       :string
#  password_digest :string           not null
#  phone_number    :string
#  sms             :boolean
#  tos             :boolean
#  updates         :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :events, foreign_key: :owner_id
  validates :email_address, uniqueness: true
  after_create :send_welcome_message
  after_save :still_guest?

  has_many :volunteer_events
  has_many :events, through: :volunteer_events

  # normalizes :email_address, with: ->(e) { e.strip.downcase }

  def name
    "#{first_name} #{last_name}"
  end

  def send_welcome_message
    nil unless guest? do
      WelcomeMailer.with(user: self).hello
    end
  end

  def still_guest?
    return unless saved_change_to_guest?

    WelcomeMailer.with(user: self).hello
  end
end
