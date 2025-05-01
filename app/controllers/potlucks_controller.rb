class PotlucksController < ApplicationController
  before_action :set_potluck, only: %i[steps update_step show thank_you edit update]
  before_action :check_owner, only: %i[steps update_step edit update]
  before_action :find_ad, only: %i[show]

  def index; end

  def show; end

  def update
    respond_to do |format|
      if @event.update(all_params)
        if (step = params[:step_check])
          format.html { redirect_to steps_potluck_path(@event, step: step.to_i + 1) }
          format.json { redirect_to steps_potluck_path(@event, step: step.to_i + 1) }
        else
          format.html { redirect_to potluck_path(@event) }
          format.json { redirect_to potluck_path(@event) }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @event = Potluck.new
  end

  def create
    guest_user if current_user.blank?
    @event = Potluck.new(potluck_params.merge(owner: current_user, start_date: params[:potluck][:end_date]))

    respond_to do |format|
      if @event.save!
        format.html { redirect_to steps_potluck_path(@event, step: 2) }
        format.turbo_stream { redirect_to steps_potluck_path(@event, step: 2) }
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
        redirect_to steps_potluck_path(@event, step: 3)
      else
        render :steps, status: :unprocessable_entity
      end
    when 3
      if @event.update(selection_params)
        redirect_to steps_potluck_path(@event, step: 4)
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
        if current_user.events.count + 1 >= 2
          redirect_to pro_path
        else
          current_user.events << @event
          send_emails
          TwilioService.call(current_user, 'welcome')
          redirect_to potluck_path(@event)
        end
      else
        respond_to do |format|
          format.html do
            render :steps, locals: { user: current_user, step: 6, url: update_step_potluck_path(@event, step: 6) },
                           status: :unprocessable_entity
          end
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def thank_you; end

  private

  def find_ad
    @ad = Ad.random_for_event(@event, 'top')
    @ad2 = Ad.random_for_event(@event, 'bottom')
    return unless @ad || @ad2

    if @ad
      @ad.increment!(:views)
    elsif @ad2
      @ad2.increment!(:views)
    end
  end

  def redirect_after_update
    if current_user.guest?
      redirect_to steps_potluck_path(@event, step: 5)
    else
      send_emails
      redirect_to potluck_path(@event)
    end
  end

  def set_potluck
    @event = Potluck.find(params[:id])
  end

  def potluck_params
    params.require(:potluck).permit(:name, :start_date, :preferred_time, :end_date, :type)
  end

  def location_params
    params.require(:potluck).permit(:address1, :address2, :city, :state, :postal_code, :country)
  end

  def selection_params
    params.require(:potluck).permit(
      selections_attributes: %i[id name quantity special_note bringing]
    )
  end

  def preferences_params
    params.require(:potluck).permit(:dietary_restrictions, :allergies, :special_message)
  end

  def user_params
    params.require(:user).permit(:email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates,
                                 :password, :password_confirmation, :area_code)
  end

  def all_params
    params.require(:potluck).permit(:bringing, :type, :start_date, :stage, :fav_rest, :end_date, :address1, :address2, :city, :state, :postal_code, :country, :recipent_name, :recipent_email, :name, :date_range,
                                    :dietary_restrictions, :allergies, :special_message, :adults, :kids, :least,
                                    :preferred_time, :fav_rest, :shabbat_instructions)
  end

  def check_owner
    if current_user == @event.owner
      current_user
    else
      redirect_to new_session_path
    end
  end

  def send_emails
    OwnerMailer.with(user: current_user, event: @event).notification.deliver_later
  end
end
