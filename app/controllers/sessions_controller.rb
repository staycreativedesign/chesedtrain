class SessionsController < ApplicationController
  def new; end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      session[:user_id] = user.id
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: 'Try another email address or password.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end
end
