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

  def volunteer_update
    @event = params[:event]
    @owner = @event.owner
    @task = params[:task]
    @volunteer = params[:volunteer]

    mail(to: @owner.email_address, subject: 'A Volunteer has updated what their bringing!')
  end

  def volunteer_removed
    @event = params[:event]
    @owner = @event.owner
    @task = params[:task]
    @volunteer = params[:volunteer]

    @date = if @event.type == 'ChesedTrain'
              [@task.try(:event_date)&.date_weekday, @task.try(:event_date)&.date_month, @task.try(:event_date)&.date_number,
               @task.try(:date_weekday), @task.try(:date_month), @task.try(:date_number)].compact.join(' ')
            else
              @task.potluck_date.strftime('%A %b %d')
            end

    mail(to: @owner.email_address, subject: "A Volunteer has removed themselves from the event on #{@date}")
  end
end
