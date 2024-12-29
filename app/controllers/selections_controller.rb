class SelectionsController < ApplicationController
  before_action :set_event, :set_selection, only: %i[update show volunteer setup_volunteer add_volunteer]

  def new
    @selections = @event.selections
  end

  def update
  end

  def show
  end

  def volunteer
    @user = current_user || User.new
  end

  def add_volunteer
    if @selection.update(selection_params.merge(volunteer: current_user))
      @event.volunteers << current_user
      OwnerMailer.with(event: @event, task: @selection, volunteer: current_user).volunteer_signup.deliver_now
      RecipientMailer.with(event: @event, task: @selection, volunteer: current_user).volunteer_signup.deliver_now

      if @event.type == "ChesedTrain"
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
      start_new_session_for @user
      if @event.type == "ChesedTrain"
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
    params.expect(event: [ :address1, :address2, :city, :state ])
  end

  def set_event
    if params[:chesed_train_id].present?
      @event = Event.find(params[:chesed_train_id])
    else
      @event = Event.find(params[:potluck_id])
    end
  end

  def set_selection
    if @event.type == "ChesedTrain"
      @selection = EventDate.find(params[:id])

    else
      @selection = Selection.find(params[:id])
    end
  end

  def user_params
    params.expect(user: [ :email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates, :password, :password_confirmation ])
  end

  def selection_params
  if params[:selection].present?
    params.expect(selection: [ :bringing, :special_note ])
  else
    params.expect(event_date: [ :bringing, :special_note ])
  end
  end
end
