class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :guest_user, :authorized, :check_owner

  def current_user
    @current_user ||= User.find_by(session[:user_id])
  end

  def authorize
    return if current_user

    session[:user_id] = nil
    redirect_to '/login'
    flash[:danger] = 'You need to login or register to access this page'
  end

  def guest_user
    binding.pry
    @guest_user ||= User.create(guest: true) do |user|
      user.first_name = 'Guest'
      user.last_name = 'Guest'
      user.email_address = "guest_#{SecureRandom.uuid}@example.com"
      user.phone_number = '1800'
      user.password = SecureRandom.hex(10) # Random password
    end

    session[:user_id] = @guest_user.id
  end
end
