class ContactMailer < ApplicationMailer
  default from: 'notifications@chesedtrain.com'

  def contact_message
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email_address = params[:email_address]
    @message = params[:message]
    mail(to: 'foo@aol.com', subject: 'Contact us')
  end
end
