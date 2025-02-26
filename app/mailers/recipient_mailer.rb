class RecipientMailer < ApplicationMailer
  default from: 'notifications@chesedtrain.com'

  def notification
    @event = params[:event]
    @email = @event.recipent_email
    mail(to: @email, subject: 'Welcome to Chesed Train!')
  end

  def recipient_notification
    @event = params[:event]
    @email = @event.recipent_email
    mail(to: @email, subject: 'A Chesed Train has been set up on your behalf!')
  end

  def volunteer_signup
    @event = params[:event]
    @task = params[:task]
    @recipient = @event.recipent_email
    mail(to: @event.recipent_email, subject: 'A Volunteer Has Signed Up!')
  end
end
