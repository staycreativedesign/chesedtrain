class EventReminderMailer < ApplicationMailer
  default from: 'notifications@chesedtrain.com'
  def volunteer_reminder(event)
    @event = Event.find(event)
    @volunteers = @event.volunteers
    mail(to: @owner.email_address, subject: 'Reminder: Your Chesed Train Task is Coming Up')
  end
end
