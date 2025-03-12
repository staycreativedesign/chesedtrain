module Admin
  class PotlucksController < DashboardsController
    before_action :find_potluck, except: [:index]
    add_breadcrumb 'Potlucks', :admin_potlucks_path

    def index
      @events = Event.joins(:owner).where(status: :opened, type: 'Potluck', users: { guest: false })
    end

    def show
      add_breadcrumb @event.name
    end

    private

    def find_potluck
      @event = Event.find(params[:id])
    end
  end
end
