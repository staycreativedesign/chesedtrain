module Admin
  class DashboardsController < CheckRoleController
    layout 'admin_application'
    add_breadcrumb 'Home', :admin_dashboard_path

    def show
      @events = Event.joins(:owner).where(status: :opened, users: { guest: false })
    end
  end
end
