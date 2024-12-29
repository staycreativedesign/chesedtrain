class OwnerMailer < ApplicationMailer
  default from: 'notifications@chesedtrain.com'

  def notification
    @owner = params[:user]
    @event = params[:event]
    mail(to: @owner.email_address, subject: 'Welcome to Chesed Train!')
  end

  def volunteer_signup
    @event = params[:event]
    @owner = @event.owner
    @task = params[:task]
    @volunteer = params[:volunteer]
    mail(to: @owner.email_address, subject: 'A Volunteer Has Signed Up!')
  end
end
