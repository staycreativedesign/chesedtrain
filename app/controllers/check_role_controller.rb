class CheckRoleController < ApplicationController
  before_action :check_role

  def check_role
    redirect_to login_path unless current_user.present? && current_user.is_admin?
  end
end
