class TwilioService
  include ActionView::Helpers::UrlHelper
  def self.call(user, message, **kwargs)
    new(user, message, **kwargs).call
  end

  def initialize(user, message, **kwargs)
    @user = user
    @message = message
    @volunteer = kwargs[:volunteer_name]
    @bringing = kwargs[:bringing]
    @date = kwargs[:date]
  end

  attr_reader :bringing, :date, :volunteer

  def call
    return unless @user.sms?

    account_sid = Rails.application.credentials.dig(:twilio, :auth)
    auth_token = Rails.application.credentials.dig(:twilio, :token)

    @client = Twilio::REST::Client.new(account_sid, auth_token)

    @client.messages.create(
      body: final_message(@message),
      from: '+18778459101',
      to: @user.area_code + @user.phone_number
    )
  end

  private

  def final_message(message)
    case message
    when 'welcome'
      "Hi #{@user.first_name}, welcome to Chesed Train! Log in here: #{Rails.application.routes.url_helpers.login_url(protocol: 'https')}. Use your dashboard to set up Chesed Trains, manage tasks, or sign up to volunteer. Let’s get started!"
    when 'volunteer_joined_chesed_train'
      "A volunteer has joined your Chesed Train! Log in here: #{Rails.application.routes.url_helpers.login_url(protocol: 'https')} and view your Chesed Train!"

    when 'volunteer_joined_potluck'
      "A volunteer has joined your Potluck! Log in here: #{Rails.application.routes.url_helpers.login_url(protocol: 'https')} and view your Potluck!"

    when 'chesed_train'
      'Thank you for creating a Chesed Train, you will be notified by text message when someone volunteers'

    when 'potluck'
      'Thank you for creating a Pot Luck, you will be notified by text message when someone volunteers'

    when 'potluck_updated'
      "#{volunteer} is now bringing #{bringing} on #{date}"

    when 'chesed_train_removed'
      "#{volunteer} has left the Chesed Train and will not be bringing #{bringing} on #{date}"

    when 'potluck_day_removed'
      "#{volunteer} has left the Potluck and will not be bringing #{bringing} on #{date}"

    when 'volunteer'
      'Thank you for volunteering! You will receive a reminder when to bring your item.'
    end
  end
end
