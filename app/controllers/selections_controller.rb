class SelectionsController < ApplicationController
  before_action :set_event, :set_selection, only: %i[update show volunteer setup_volunteer add_volunteer]

  def new
    @selections = @event.selections
  end

  def update; end

  def show; end

  def volunteer
    @user = current_user || User.new
  end

  def add_volunteer
    if @selection.update!(selection_params.merge(volunteer: current_user))
      @event.volunteers << current_user

      # OwnerMailer.with(event: @event, task: @selection, volunteer: current_user).volunteer_signup.deliver_now
      TwilioService.call(current_user, 'volunteer')
      TwilioService.call(@event.owner, 'volunteer_joined_potluck')
      # RecipientMailer.with(event: @event, task: @selection, volunteer: current_user).volunteer_signup.deliver_now

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
        redirect_to volunteer_chesed_train_event_date_path(@event, @selection)
      else
        redirect_to volunteer_potluck_selection_path(@event, @selection)
      end
    else
      render :volunteer, status: :unprocessable_entity
    end
  end

  private

  def location_params
    params.expect(event: %i[address1 address2 city state])
  end

  def set_event
    @event = if params[:chesed_train_id].present?
               Event.find(params[:chesed_train_id])
             else
               Event.find(params[:potluck_id])
             end
  end

  def set_selection
    @selection = if @event.type == 'ChesedTrain'
                   EventDate.find(params[:id])

                 else
                   Selection.find(params[:id])
                 end
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
