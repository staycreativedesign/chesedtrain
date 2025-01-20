module Admin
  class DashboardsController < CheckRoleController
    layout 'admin_application'
    add_breadcrumb 'Home', :admin_dashboard_path

    def show
      @events = Event.where(status: :opened)
    end
  end
end
