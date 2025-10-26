class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :check_session, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @events = Event.where(owner: current_user).where('end_date >= ?', Date.today)
    @past_events = Event.where(owner: current_user).where('end_date < ?', Date.today)
    @potluck_events = current_user.selections_as_volunteer.includes(:potluck)
    @chesed_events = current_user.event_dates_as_volunteer.includes(:chesed_train)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save && verify_recaptcha(message: 'Cannot verify your recaptcha')
        session[:user_id] = @user.id
        current_user = @user

        WelcomeMailer.with(user: current_user).hello.deliver_now
        TwilioService.call(current_user, 'welcome')
        format.html { redirect_to new_payment_path, notice: 'Account was successfully created.' }
        format.json { redirect_to fallback_location: new_payment_path }
      else
        format.html do
          flash.now[:notice] = @user.errors.full_messages
          render :new, status: :unprocessable_entity
        end

        format.json do
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def check_session
    redirect_to new_session_path unless params[:id].to_i == current_user.id
  end

  def user_params
    params.require(:user)
          .permit(:email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates, :area_code,
                  :password, :password_confirmation, :nickname)
  end
end
