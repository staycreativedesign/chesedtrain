class VolunteerMailer < ApplicationMailer
  default from: 'notifications@chesedtrain.com'

  def volunteer_notification
    @volunteer = params[:user]
    @event = params[:event]
    mail(to: @owner.email_address, subject: 'Welcome to Chesed Train!')
  end

  def reminder(event, time, type)
    @volunteer = event[0]
    @event = event[1]
    @time = time
    @type = type
    mail(to: [@volunteer.email_address], subject: 'Reminder: Your Chesed Train Task is Coming Up')
  end
end
