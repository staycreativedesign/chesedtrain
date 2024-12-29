class PotlucksController < ApplicationController
  before_action :set_potluck, only: %i[steps update_step show thank_you edit update]
  before_action :check_owner, only: %i[steps update_step edit update]

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
    @event = Potluck.new(potluck_params.merge(owner: current_user))

    respond_to do |format|
      if @event.save
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

    return unless @step == 5

    @user = User.new
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
      @user = User.new(user_params.merge(guest: false))
      if @user.save
        @event.update(owner: @user)
        session[:user_id] = @user.id
        current_user = @user

        if current_user.events.count > 1 && !current_user.is_paying? || !current_user.is_admin?
          redirect_to pro_path
        else
          send_emails
          redirect_to potluck_path(@event)
        end
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
        redirect_to potluck_path(@event)
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
    params.require(:potluck).permit(:name, :start_date, :preferred_time)
  end

  def location_params
    params.require(:potluck).permit(:address1, :address2, :city, :state)
  end

  def selection_params
    params.require(:potluck).permit(
      selections_attributes: %i[id name quantity special_note]
    )
  end

  def preferences_params
    params.require(:potluck).permit(:dietary, :restrictions, :allergies, :special_message)
  end

  def user_params
    params.require(:user).permit(:email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates, :password,
                                 :password_confirmation)
  end

  def all_params
    params.expect(potluck).permit(:type, :start_date, :stage, :fav_rest,  :end_date, :address1, :address2, :city, :state,
                                  :recipent_name, :recipent_email, :name, :date_range, :dietary_restrictions, :allergies,
                                  :special_message, :adults, :kids, :least, :preferred_time, :fav_rest, :shabbat_instructions)
  end

  def check_owner
    if current_user == @event.owner
    else
      redirect_to new_session_path
    end
  end

  def send_emails
    OwnerMailer.with(user: current_user, event: @event).notification.deliver_later
    RecipientMailer.with(recipient_email: @event.recipent_email, event: @event).notification.deliver_later
  end
end
