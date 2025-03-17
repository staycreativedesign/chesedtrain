class ContactController < ApplicationController
  def new; end

  def create
    if verify_recaptcha(message: 'Cannot verify your recaptcha')

      ContactMailer.with(first_name: params[:first_name],
                         last_name: params[:last_name],
                         email_address: params[:email_address],
                         message: params[:message]).contact_message.deliver_now

      redirect_to contact_thank_you_path
    else
      flash[:notice] = 'Email not found'
      redirect_to new_contact_path
    end
  end
end
