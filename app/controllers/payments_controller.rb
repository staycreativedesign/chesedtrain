class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def payment_success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])

    user = if (user = User.find_by(email_address: session.customer_details.email))
             user.update(
               is_paying: true,
               stripe_customer_id: session.customer,
               stripe_subscription_id: session.subscription
             )
             user

           else
             User.create(first_name: session.custom_fields[0].text.value,
                         last_name: session.custom_fields[1].text.value,
                         is_paying: true,
                         email_address: session.customer_details.email,
                         tos: true, sms: false, guest: false,
                         password: SecureRandom.hex(10),
                         stripe_customer_id: session.customer,
                         stripe_subscription_id: session.subscription)

           end
    foo = User.find_by(toke: user.toke)

    session[:user_id] = foo.id
    @current_user = foo
    current_user
    WelcomeMailer.with(user: session.customer_details.email).subscribe.deliver_now
    redirect_to pro_account_path
  end

  def pro; end

  def unsubscribe; end

  def unsubscribe_action
    begin
      Stripe::Subscription.cancel(current_user.stripe_subscription_id)
    rescue StandardError => e
      Rails.logger info "Unhandled event type: #{e}"
    end

    current_user.update(is_paying: false, stripe_subscription_id: nil)
    redirect_to user_path(current_user)
    flash[:notice] = 'Account is no longer subscribed'
  end

  def success; end

  def create_payment_link
    # Create a Payment Link with a price and description
    payment_link = Stripe::PaymentLink.create(
      line_items: [
        {
          price: 'price_1QoJ2DFPajux6JXVgPOOJD8N',
          quantity: 1
        }
      ],
      after_completion: {
        type: 'redirect',
        redirect: {
          url: 'https://chesedtrain.com/payment-success?session_id={CHECKOUT_SESSION_ID}'
        }
      },

      phone_number_collection: {
        enabled: true
      },
      metadata: {
        user_id: current_user&.id
      },
      custom_fields: [
        {
          key: 'first_name',
          label: { type: 'custom', custom: 'First Name' },
          type: 'text',
          optional: false
        },
        {
          key: 'last_name',
          label: { type: 'custom', custom: 'Last Name' },
          type: 'text',
          optional: false
        }
      ]
    )

    redirect_to payment_link.url, allow_other_host: true
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to root_path
  end

  def check_session
    redirect_to new_session_path unless params[:id].to_i == current_user.id
  end
end
