class LocationsController < ApplicationController
  before_action :set_event, only: %i[new show edit update]

  def new; end

  def edit; end

  def create; end

  def show; end

  def update
    respond_to do |format|
      if @potluck.update(location_params)
        format.html { redirect_to edit_potluck_selections_path(@potluck) }
        format.turbo_stream { redirect_to edit_potluck_selections_path(@potluck) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @potluck.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_event
    @event = Event.friendly.find(params[:potluck_id])
  end

  def location_params
    params.expect(event: %i[address1 address2 city state])
  end
end
