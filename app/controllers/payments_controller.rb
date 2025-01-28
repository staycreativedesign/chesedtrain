class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def success
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe.success_webhook

    binding.pry

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    # Handle the event
    case event['type']
    when 'checkout.session.completed'
      binding.pry
      handle_checkout_session_completed(event['data']['object'])
      binding.pry
      Rails.logger.info "PaymentIntent succeeded: #{payment_intent['id']}"
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
          price: 'price_1Qm4YnFPajux6JXViZQUZcWC',
          quantity: 1
        }
      ],
      after_completion: {
        type: 'redirect',
        redirect: {
          url: 'http://localhost:3000/payment-success'
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

  # Update user account on successful payment
  def handle_checkout_session_completed(session)
    if (user = User.find_by(email: session[:customer_details][:email]))
      user.update(
        is_paying: true,
        stripe_customer_id: session['customer'],
        stripe_subscription_id: session['subscription']
      )

      redirect_to user_path(user)
    else
      user = User.create(first_name: session[:custom_fields][0]['text']['value'],
                         last_name: session[:custom_fields][1]['text']['value'],
                         is_paying: true,
                         email_address: session[:customer_details][:email],
                         phone_number: session[:customer_details][:phone],
                         tos: true, sms: true, guest: false,

                         stripe_customer_id: session['customer'],
                         stripe_subscription_id: session['subscription'])
      session[:user_id] = user.id
      redirect_to user_path(user)

    end
    Rails.logger.info "User #{user.id} updated with active subscription."
  end
end
