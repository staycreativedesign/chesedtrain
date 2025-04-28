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
#  toke                   :string           default("cb53e62275d4f169a50c")
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :events, foreign_key: :owner_id, dependent: :destroy
  has_many :selections_as_volunteer, class_name: "Selection", foreign_key: "volunteer_id"
  has_many :owned_events, class_name: 'Event', foreign_key: 'owner_id', dependent: :destroy


  validates :email_address, uniqueness: true
  after_create :send_welcome_message
  after_save :still_guest?

  has_many :volunteer_events, dependent: :destroy
  has_many :events, through: :volunteer_events, dependent: :destroy
  before_save :normalize_email
  before_destroy :nullify_selections


  def nullify_selections
    selections_as_volunteer.update_all(volunteer_id: nil)
  end

  def normalize_email
    self.email_address = email_address.strip.downcase if email_address.present?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def send_welcome_message
    nil unless guest? do
      WelcomeMailer.with(user: self).hello.deliver_now
    end
  end

  def still_guest?
    nil unless guest? do
      WelcomeMailer.with(user: self).hello.deliver_now
    end
  end
end
