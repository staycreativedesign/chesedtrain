class TwilioReminderService
  include ActionView::Helpers::UrlHelper
  def self.call(event, time, message)
    new(event, time, message).call
  end

  def initialize(event, time, message)
    @volunteer = event[0]
    @event = event[1]
    @time = time
    @message = message
  end

  attr_reader :volunteer, :event, :time, :message

  def call
    return unless volunteer.sms?

    account_sid = Rails.application.credentials.dig(:twilio, :auth)
    auth_token = Rails.application.credentials.dig(:twilio, :token)

    @client = Twilio::REST::Client.new(account_sid, auth_token)

    @client.messages.create(
      body: final_message(message),
      from: '+18778459101',
      to: volunteer.area_code + volunteer.phone_number
    )
  end

  private

  def final_message(message)
    case message
    when 'chesed_train'
      "Hi #{volunteer.first_name}, this is a reminder for your upcoming Chesed Train task: #{event.bringing} on #{event.date_weekday} #{event.date_month}/#{event.date_number} at #{time}."
    when 'potluck'
      "Hi #{volunteer.first_name}, this is a reminder for your upcoming Potluck task: #{event.bringing} on #{event.potluck.start_date.strftime('%A %m/%d')} at #{time}."
    end
  end

  def login
    Rails.application.routes.url_helpers.login_url(protocol: 'https')
  end
end
