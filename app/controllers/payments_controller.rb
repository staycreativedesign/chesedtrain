class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def payment_success; end

  def unsubscribe; end

  def unsubscribe_action
    begin
      Stripe::Subscription.cancel(current_user.stripe_subscription_id)
    rescue StandardError => e
      Rails.logger.info "Unhandled event type: #{e}"
    end

    current_user.update(is_paying: false, stripe_subscription_id: nil)
    redirect_to user_path(current_user)
    flash[:notice] = 'Account is no longer subscribed'
  end

  def success
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe.success_webhook

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      puts event
    rescue JSON::ParserError
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    # Handle the event
    case event['type']
    when 'checkout.session.completed', 'charge.succeeded'
      handle_checkout_session_completed(event['data']['object'])
    else
      Rails.logger.info "Unhandled event type: #{event['type']}"
    end

    render json: { message: 'Success' }, status: 200
  end

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
          url: 'https://chesedtrain.com/payment-success'
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

  private

  def handle_checkout_session_completed(session)
    payment_intent_id = session['payment_intent']
    payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
    invoice = Stripe::Invoice.retrieve(payment_intent.invoice)
    subscription_id = invoice.subscription

    first_name, last_name = session['billing_details']['name'].split(' ', 2)

    if (user = User.find_by(email_address: session[:billing_details][:email]))
      user.update(
        is_paying: true,
        stripe_customer_id: session['customer'],
        stripe_subscription_id: subscription_id
      )

    else
      user = User.create(first_name: first_name,
                         last_name: last_name,
                         is_paying: true,
                         email_address: session[:billing_details][:email],
                         tos: true, sms: false, guest: false,
                         password: SecureRandom.hex(10),
                         stripe_customer_id: session['customer'],
                         stripe_subscription_id: subscription_id)
    end

    WelcomeMailer.with(user: user).subscribe.deliver_now
    Rails.logger.info "User #{user.id} updated with active subscription."
    user
  end
end
