module Admin
  class EventsController < CheckRoleController
    def destroy
      @event = Event.find(params[:id])
      @event.destroy
      respond_to do |format|
        format.html { redirect_to admin_dashboard_path, notice: 'Event deleted' }
        format.js # You need a corresponding destroy.js.erb to handle the view update via AJAX
      end
    end
  end
end
