module Admin
  class ChesedTrainsController < DashboardsController
    before_action :find_chesed_train, except: [:index]

    def index
      @events = Event.joins(:owner).where(status: :opened, type: 'ChesedTrain', users: { guest: false })
      @type = 'chesed'
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
