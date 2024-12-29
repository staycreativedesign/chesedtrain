class SessionsController < ApplicationController
  def new; end

  def create
    if user = User.find_by(email_address: params[:email_address])&.authenticate(params[:password])
      session[:user_id] = user.id
      @current_user = user
      redirect_to user_path(current_user)
    else
      redirect_to new_session_path, alert: 'Try another email address or password.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end
end
