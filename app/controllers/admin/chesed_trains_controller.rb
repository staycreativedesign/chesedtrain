module Admin
  class ChesedTrainsController < DashboardsController
    before_action :find_chesed_train, except: [:index]
    add_breadcrumb 'Chesed Trains', :admin_chesed_trains_path

    def index
      @events = Event.where(status: :opened, type: 'ChesedTrain')
    end

    def show
      add_breadcrumb @event.name
    end

    private

    def find_chesed_train
      @event = Event.find(params[:id])
    end
  end
end
