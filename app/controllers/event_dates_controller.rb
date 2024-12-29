class EventDatesController < ApplicationController
  before_action :set_event_date, only: %i[ show edit update destroy ]

  # GET /event_dates or /event_dates.json
  def index
    @event_dates = EventDate.all
  end

  # GET /event_dates/1 or /event_dates/1.json
  def show
  end

  # GET /event_dates/new
  def new
    @event_date = EventDate.new
  end

  # GET /event_dates/1/edit
  def edit
  end

  # POST /event_dates or /event_dates.json
  def create
    @event_date = EventDate.new(event_date_params)

    respond_to do |format|
      if @event_date.save
        format.html { redirect_to @event_date, notice: "Event date was successfully created." }
        format.json { render :show, status: :created, location: @event_date }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_dates/1 or /event_dates/1.json
  def update
    respond_to do |format|
      if @event_date.update(event_date_params)
        format.html { redirect_to @event_date, notice: "Event date was successfully updated." }
        format.json { render :show, status: :ok, location: @event_date }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_dates/1 or /event_dates/1.json
  def destroy
    @event_date.destroy!

    respond_to do |format|
      format.html { redirect_to event_dates_path, status: :see_other, notice: "Event date was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_date
      @event_date = EventDate.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def event_date_params
      params.expect(event_date: [ :event_id ])
    end
end
