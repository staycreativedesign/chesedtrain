class VolunteerMailer < ApplicationMailer
  default from: "notifications@chesedtrain.com"

  def volunteer_notification
    @volunteer = params[:user]
    @event = params[:event]
    mail(to: @owner.email_address, subject: "Welcome to Chesed Train!")
  end

  def reminder(event)
    @event = event
    @volunteer = @event.volunteer
    begin
      @event_type = event.potluck
      @event_type = event.chesed_train
    end
    mail(to: [ @volunteer.email_address ], subject: "Reminder: Your Chesed Train Task is Coming Up")
  end
end
