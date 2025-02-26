class ChesedTrainsController < ApplicationController
  before_action :set_chesed_train, only: %i[steps update_step show thank_you edit update]
  before_action :check_owner, only: %i[steps update_step edit update]
  before_action :check_date, only: %i[edit update]

  def index; end

  def show; end

  def update
    respond_to do |format|
      update_event_dates(params[:chesed_train][:start_date], params[:chesed_train][:end_date], @event, params)
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
    guest_user if current_user.blank?
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
        start_date, end_date = params[:chesed_train][:date_range].split(' to ')

        end_date = start_date if end_date.blank?

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

    when 6
      current_user = check_owner

      if current_user.update(user_params.merge(guest: false))
        @event.update(owner: current_user)
        session[:user_id] = current_user.id
        if current_user.events.count + 1 >= 2
          redirect_to pro_path
        else
          current_user.events << @event
          send_emails
          TwilioService.call(current_user, 'welcome')
          redirect_to chesed_train_path(@event)
        end
      else
        respond_to do |format|
          format.html { render :steps, status: :unprocessable_entity }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def thank_you; end

  private

  def update_event_dates(start_date, end_date, event, params)
    return if params[:chesed_train][:date_range] == event.date_range

    start_date, end_date = params[:chesed_train][:date_range].split(' to ').map { |date| Date.parse(date) }

    # Fetch existing dates for the event
    @dates = EventDate.where(chesed_train_id: event.id)

    # Delete records where start_date is greater and end_date overlaps
    @dates.where('full_date < ?', start_date)
          .destroy_all

    # Check if new EventDates need to be created
    # Create a new EventDate if there are no existing dates covering the range
    return unless @dates.where('full_date <= ? AND full_date >= ?', start_date, end_date).empty?

    event.update(start_date: start_date, end_date: end_date)
    (start_date..end_date).each do |date|
      full_date = event.event_dates.pluck(:full_date)
      next if full_date.map(&:to_date).include?(date.to_date)

      EventDate.create!(
        date_number: date.day,
        date_weekday: date.strftime('%A'),
        date_month: date.month,
        full_date: date,
        chesed_train_id: event.id
      )
    end
  end

  def create_event_dates(start_date, end_date, event)
    event.update(start_date: start_date, end_date: end_date)
    (start_date..end_date).each do |date|
      full_date = event.event_dates.pluck(:full_date)
      next if full_date.include?(date)

      EventDate.create!(
        date_number: Date.parse(date).day,
        date_weekday: Date.parse(date).strftime('%A'),
        date_month: Date.parse(date).month,
        full_date: Date.parse(date),
        chesed_train_id: event.id
      )

      return if end_date == start_date
    end
  end

  def redirect_after_update
    if current_user.guest?
      redirect_to steps_chesed_train_path(@event, step: 5)
    else
      send_emails
      TwilioService.call(current_user, 'chesed_train')
      redirect_to chesed_train_path(@event)
    end
  end

  def set_chesed_train
    @event = Event.find(params[:id])
  end

  def chesed_train_params
    params.require(:chesed_train).permit(:recipent_name, :recipent_email, :name, :type)
  end

  def location_params
    params.require(:chesed_train).permit(:address1, :address2, :city, :state, :postal_code, :country)
  end

  def date_params_valid?
    return false if params[:chesed_train][:date_range].blank?

    params[:chesed_train][:date_range]
  end

  def preferences_params
    params.require(:chesed_train).permit(:dietary_restrictions, :allergies, :special_message, :adults,
                                         :kids, :least, :preferred_time, :fav_rest, :shabbat_instructions, date_range: %i[start_date end_date])
  end

  def user_params
    params.require(:user).permit(:email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates,
                                 :password, :area_code, :password_confirmation)
  end

  def all_params
    params.require(:chesed_train).permit(:type, :start_date, :stage, :fav_rest, :end_date, :address1, :address2, :city, :state, :postal_code, :country, :recipent_name, :recipent_email, :name, :dietary_restrictions, :allergies,
                                         :special_message, :adults, :kids, :least, :preferred_time, :fav_rest,
                                         :shabbat_instructions, :date_range)
  end

  def check_owner
    if current_user.id == @event.owner.id
      current_user
    else
      redirect_to new_session_path
    end
  end

  def send_emails
    OwnerMailer.with(user: current_user, event: @event).notification.deliver_later
    RecipientMailer.with(recipient_email: @event.recipent_email, event: @event).recipient_notification.deliver_later
  end

  def check_date; end
end
