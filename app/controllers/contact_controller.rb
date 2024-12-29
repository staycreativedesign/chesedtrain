class ContactController < ApplicationController
  def new; end

  def create
    ContactMailer.with(first_name: params[:first_name],
                       last_name: params[:last_name],
                       email_address: params[:email_address],
                       message: params[:message]).contact_message.deliver_now

    redirect_to contact_thank_you_path
  end
end
