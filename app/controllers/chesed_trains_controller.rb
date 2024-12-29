class ChesedTrainsController < ApplicationController
  before_action :set_chesed_train, only: [ :steps, :update_step, :show, :thank_you, :edit, :update ]
  before_action :check_owner, only: [ :steps, :update_step, :edit, :update ]

  def index
  end

  def show
  end

  def update
    respond_to do |format|
      if @event.update(all_params)
        if (step = params[:step_check])
          format.html { redirect_to steps_chesed_train_path(@event, step: step.to_i + 1) }
          format.json { redirect_to steps_chesed_train_path(@event, step: step.to_i + 1) }
        else
          format.html { redirect_to chesed_train_path(@event) }
          format.json { redirect_to chesed_train_path(@event) }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @event = ChesedTrain.new
  end

  def create
    guest_user if !current_user
    @event = ChesedTrain.new(chesed_train_params.merge(owner: current_user))

    respond_to do |format|
      if @event.save
        format.html { redirect_to steps_chesed_train_path(@event, step: 2) }
        format.turbo_stream { redirect_to steps_chesed_train_path(@event, step: 2) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def steps
    @step = params[:step].to_i

    if @step == 5
     @user = User.new
    end
  end

  def update_step
    @step = params[:step].to_i
    case @step
    when 2
      if @event.update(location_params)
        redirect_to steps_chesed_train_path(@event, step: 3)
      else
        render :steps, status: :unprocessable_entity
      end
    when 3
      if date_params_valid?
        start_date, end_date = params[:chesed_train][:date_range].split(" to ")
        create_event_dates(start_date, end_date, @event)
        @event.update(start_date: start_date, end_date: end_date)

        redirect_to steps_chesed_train_path(@event, step: 4)
      else
        render :steps, status: :unprocessable_entity
      end
    when 4
      if @event.update(preferences_params)
        redirect_after_update
      else
        render :steps, status: :unprocessable_entity
      end
    when 5
      @user = User.new(user_params.merge(guest: false))
      if @user.save
        @event.update(owner: @user)
        Current.session.update(user: @user)
        send_emails
        redirect_to chesed_train_path(@event)
      else
        respond_to do |format|
          format.html { render :steps, status: :unprocessable_entity }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    when 6
      if current_user.update(user_params.merge(guest: false))
        @event.update(owner: current_user)
        Current.session.update(user: current_user)
        send_emails
        redirect_to chesed_train_path(@event)
      else
        respond_to do |format|
          format.html { render :steps, locals: { user: current_user, step: 6, url: update_step_chesed_train_path(@event, step: 6) }, status: :unprocessable_entity  }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def thank_you
  end

  private

  def create_event_dates(start_date, end_date, event)
    (start_date..end_date).each do |date|
      event.event_dates.create!(
        date_number: Date.parse(date).day,
        date_weekday: Date.parse(date).strftime("%A"),
        date_month: Date.parse(date).month,
        full_date: Date.parse(date)
      )
    end
  end

  def redirect_after_update
    if current_user.guest?
      redirect_to steps_chesed_train_path(@event, step: 5)
    else
      send_emails
      redirect_to chesed_train_path(@event)
    end
  end

  def set_chesed_train
    @event = ChesedTrain.find(params[:id])
  end


  def chesed_train_params
    params.expect(chesed_train: [ :recipent_name, :recipent_email, :name ])
  end

  def location_params
    params.expect(chesed_train: [ :address1, :address2, :city, :state ])
  end


  def date_params_valid?
    return false if params[:chesed_train][:date_range].blank?
    params[:chesed_train][:date_range]
  end

  def preferences_params
    params.expect(chesed_train: [ :date_range, :dietary_restrictions, :allergies, :special_message, :adults, :kids, :least, :preferred_time, :fav_rest, :shabbat_instructions ])
  end

  def user_params
    params.expect(user: [ :guest, :email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates, :password, :password_confirmation ])
  end

  def all_params
    params.expect(chesed_train: [ :full_date, :type, :start_date, :stage, :fav_rest, :end_date, :address1, :address2, :city, :state, :recipent_name, :recipent_email, :name, :date_range, :dietary_restrictions, :allergies, :special_message, :adults, :kids, :least, :preferred_time, :fav_rest, :shabbat_instructions ])
  end

  def send_emails
    OwnerMailer.with(user: current_user, event: @event).notification.deliver_later
    RecipientMailer.with(recipient_email: @event.recipent_email, event: @event).notification.deliver_later
  end
end
