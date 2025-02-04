module Admin
  class UsersController < DashboardsController
    before_action :find_user, except: %i[index new create]

    add_breadcrumb 'Users', :admin_users_path

    def index
      @users = User.where(guest: false).order(:last_name)
    end

    def new
      add_breadcrumb 'New User'
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to admin_users_path, notice: 'User Created' }
          format.json { redirect_to admin_users_path, notice: 'User Created' }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /users/1 or /users/1.json
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
          format.html { redirect_to admin_users_path, status: :ok, notice: 'User was successfully updated.' }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def show
      add_breadcrumb @user.name
      @events = Event.where(owner: @user)
      @chesed_trains = EventDate.where(volunteer: @user)
      @potlucks = Selection.where(volunteer: @user)
    end

    def destroy
      @user = User.find(params[:id])

      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: 'User deleted' }
        format.js # You need a corresponding destroy.js.erb to handle the view update via AJAX
      end
    end

    private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email_address, :first_name, :last_name, :phone_number, :sms, :tos, :updates,
                                   :password_confirmation, :password, :is_admin, :is_paying, :area_code)
    end
  end
end
