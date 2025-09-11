class YomTovsController < ApplicationController
  before_action :find_event, only: [:index]

  def index
    @event_dates = @event.event_dates.select { |ed| %w[Friday Saturday].include?(ed.date_weekday) }
  end

  def update
    success = true

    if params[:event_date] && params[:event_date][:selections_attributes]
      params[:event_date][:selections_attributes].each do |_, selection_params|
        selection = Selection.find(selection_params[:id])
        success = false unless selection.update(selection_params.permit(:id, :name, :quantity, :special_note))
      end
    end
    flash.now[:notice] = 'Updated Shabbat'
    @event = Event.find(params[:id])
    @event_dates = @event.event_dates.select { |ed| %w[Friday Saturday].include?(ed.date_weekday) }
    render :index, status: :ok
  end

  private

  def find_event
    @event = Event.friendly.find(params[:id])
  end
end
