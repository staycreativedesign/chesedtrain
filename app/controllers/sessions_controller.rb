class SessionsController < ApplicationController
  def new
    @event = params[:event]
    @event_id = params[:event_id]
    @selection = params[:selection_id]
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user&.authenticate(params[:password]) && verify_recaptcha(message: 'Cannot verify your recaptcha')
      session[:user_id] = user.id
      @current_user = user
      redirect_to determine_redirect_path(params)
    else
      redirect_to new_session_path, alert: 'Invalid email address or password.'
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

  private

  def determine_redirect_path(params)
    return user_path(@current_user) unless params[:event].present?

    case params[:event]
    when 'chesedtrain'
      volunteer_chesed_train_event_date_path(params[:event_id], params[:selection_id])
    else
      volunteer_potluck_selection_path(params[:event_id], params[:selection_id])
    end
  end
end
