class ContactMailer < ApplicationMailer
  default from: 'notifications@chesedtrain.com'

  def contact_message
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email_address = params[:email_address]
    @message = params[:message]
    mail(to: 'info@chesedtrain.com', subject: 'Contact us')
  end

  def welcome_message
    @user = user
    mail(to: @user.email_address, subject: 'Welcome to Chesed Train!')
  end
end
