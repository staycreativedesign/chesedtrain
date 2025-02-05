class PasswordResetsController < ApplicationController
  def create
    @user = User.find_by(email_address: params[:email_address])
    if @user
      @user.update(reset_password_token: SecureRandom.hex(10), reset_password_sent_at: Time.zone.now)
      UserMailer.reset_password_email(@user).deliver_now
      flash[:notice] = 'Email sent with password reset instructions'
      redirect_to root_path
    else
      flash[:notice] = 'Email not found'
      redirect_to new_password_reset_path
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:id])
    redirect_to root_path, alert: 'Invalid or expired token' if @user.nil?
  end

  def update
    @user = User.find_by(reset_password_token: params[:id])
    if @user && params[:password].present?
      @user.update(password: params[:password], reset_password_token: nil)
      flash[:notice] = 'Password has been reset'
      redirect_to login_path
    else
      render :edit
    end
  end
end
