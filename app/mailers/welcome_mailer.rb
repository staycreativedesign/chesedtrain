class WelcomeMailer < ApplicationMailer
  default from: "notifications@chesedtrain.com"

  def hello
    @user = params[:user]
    mail(to: @user.email, subject: "Welcome to Chesed Train!")
  end
end
