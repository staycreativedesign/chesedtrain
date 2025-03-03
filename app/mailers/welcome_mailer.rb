class WelcomeMailer < ApplicationMailer
  default from: 'notifications@chesedtrain.com'

  def hello
    @user = params[:user]
    mail(to: @user.email_address, subject: 'Welcome to Chesed Train!')
  end

  def subscribe
    @user = params[:user]
    mail(to: @user.email_address, subject: 'Welcome to Chesed Train Pro!')
  end
end
