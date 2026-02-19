class SelectionsController < ApplicationController
  before_action :set_event, :set_selection, only: %i[update show volunteer setup_volunteer add_volunteer]
  before_action :set_kwargs, only: %i[destroy update]

  def new
    @selections = @event.selections
  end

  def update
    @selection = Selection.find(params[:id])
    @selection.update(bringing: params[:selection][:bringing])

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Updated Successfully'

        render turbo_stream: turbo_stream.update(
          'flash',
          partial: 'shared/alert'
        )
      end
    end

    @kwargs[:volunteer_name] = @selection.volunteer.name
    @kwargs[:bringing] = params[:selection][:bringing]
    @kwargs[:date] = @selection.potluck_date.strftime('%A %b %d')

    OwnerMailer.with(event: @selection.potluck, task: @selection,
                     volunteer: current_user).volunteer_update.deliver_now

    TwilioService.call(@selection.potluck.owner, 'potluck_updated', **@kwargs)
  end

  def destroy
    @selection = Selection.find(params[:id])

    @kwargs[:volunteer_name] = @selection.volunteer.name
    @kwargs[:bringing] = @selection.bringing
    @kwargs[:date] = @selection.potluck_date.strftime('%A %b %d')

    OwnerMailer.with(event: @selection.potluck, task: @selection,
                     volunteer: current_user).volunteer_removed.deliver_now

    TwilioService.call(@selection.potluck.owner, 'potluck_day_removed', **@kwargs)

    @selection.update(volunteer_id: nil, bringing: nil, special_note: nil)
    flash.now[:notice] = 'Stopped Volunteering'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@selection),
          turbo_stream.prepend('flash', partial: 'shared/alert')
        ]
      end
    end
  end

  def show; end

  def volunteer
    if @event.type == 'ChesedTrain'
      if params[:chesed_train_id].present? && params[:id].present? && params[:selection_id].present?
        @event_date = EventDate.find(params[:id])
        render template: 'shared/selections/yom_tov_volunteer', layout: 'application',
               locals: { event: @event_date, selection: @selection }
      else
        render template: 'shared/selections/chesed_train_volunteer', layout: 'application',
               locals: { event: @event_date, selection: @selection }
      end
    else
      render template: 'shared/selections/potlucks', layout: 'application',
             locals: { event: @event, selection: @selection }
    end
  end

  def add_volunteer
    if @selection.update!(selection_params.merge(volunteer: current_user))
      @event.volunteers << current_user
      TwilioService.call(current_user, 'volunteer')
      if @event.type == 'Potluck'
        TwilioService.call(@event.owner, 'volunteer_joined_potluck')
      else
        TwilioService.call(@event.owner, 'volunteer_joined_chesed_train')
      end
      RecipientMailer.with(event: @event, task: @selection, volunteer: current_user).volunteer_signup.deliver_now

      if @event.type == 'ChesedTrain'
        redirect_to thank_you_chesed_train_path(@event)
      else
        redirect_to thank_you_potluck_path(@event)
      end
    else
      render :volunteer, status: :unprocessable_entity
    end
  end

  def setup_volunteer
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      @current_user = @user
      TwilioService.call(current_user, 'welcome')
      if @event.type == 'ChesedTrain'
        if params[:chesed_train_id].present? && params[:id].present? && params[:selection_id].present?
          @event_date = @selection.event_date
          redirect_to volunteer_chesed_train_yom_tov_path(@event, @event_date, @selection)
        else
          @event_date = EventDate.find(params[:id])
          redirect_to volunteer_chesed_train_event_date_path(@event, @event_date)
        end
      else
        redirect_to volunteer_potluck_selection_path(@event, @selection)
      end
    else
      puts '---------------------error'
      render :volunteer, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = if params[:chesed_train_id].present?
               Event.friendly.find(params[:chesed_train_id])
             else
               Event.friendly.find(params[:potluck_id])
             end
  end

  def set_selection
    @selection = if @event.type == 'ChesedTrain'
                   if params[:chesed_train_id].present? && params[:id].present? && params[:selection_id].present?
                     Selection.find(params[:selection_id])
                   else
                     EventDate.find(params[:id])
                   end
                 else
                   Selection.find(params[:id])
                 end
  end

  def set_kwargs
    @kwargs = {}
  end

  def user_params
    params.require(:user).permit(:email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates,
                                 :password, :password_confirmation, :area_code)
  end

  def selection_params
    if params[:selection].present?
      params.require(:selection).permit(:bringing, :special_note)
    else
      params.require(:event_date).permit(:bringing, :special_note)
    end
  end
end
