# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email_address          :string           not null
#  password_digest        :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  updates                :boolean          default(TRUE)
#  tos                    :boolean
#  sms                    :boolean
#  guest                  :boolean          default(FALSE)
#  is_paying              :boolean          default(FALSE)
#  is_admin               :boolean          default(FALSE)
#  country_code           :string
#  stripe_customer_id     :string
#  stripe_subscription_id :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  area_code              :string
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :events, foreign_key: :owner_id, dependent: :destroy
  validates :email_address, uniqueness: true
  after_create :send_welcome_message
  after_save :still_guest?

  has_many :volunteer_events, dependent: :destroy
  has_many :events, through: :volunteer_events, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

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
