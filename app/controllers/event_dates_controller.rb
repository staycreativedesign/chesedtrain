class EventDatesController < ApplicationController
  before_action :set_event_date, only: %i[show edit update destroy]
  before_action :set_kwargs, only: %i[destroy update]

  # GET /event_dates or /event_dates.json
  def index
    @event_dates = EventDate.all
  end

  # GET /event_dates/1 or /event_dates/1.json
  def show; end

  # GET /event_dates/new
  def new
    @event_date = EventDate.new
  end

  # GET /event_dates/1/edit
  def edit; end

  # POST /event_dates or /event_dates.json
  def create
    @event_date = EventDate.new(event_date_params)
    @event_date.event_dates.any? { |ed| %w[Friday Saturday].include?(ed.date_weekday) }

    respond_to do |format|
      if @event_date.save
        format.html { redirect_to @event_date, notice: 'Event date was successfully created.' }
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

        format.turbo_stream do
          @kwargs[:volunteer_name] = @event_date.volunteer.name
          @kwargs[:bringing] = params[:event_date][:bringing]
          @kwargs[:date] = @event_date.full_date

          OwnerMailer.with(event: @event_date.chesed_train, task: @event_date,
                           volunteer: current_user).volunteer_update.deliver_now

          TwilioService.call(@event_date.chesed_train.owner, 'potluck_updated', **@kwargs)

          respond_to do |format|
            format.turbo_stream do
              flash.now[:notice] = 'Updated Successfully'

              render turbo_stream: turbo_stream.update(
                'flash',
                partial: 'shared/alert'
              )
            end
          end
        end

        format.html { redirect_to @event_date, notice: 'Event date was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_date }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_dates/1 or /event_dates/1.json
  def destroy
    respond_to do |format|
      format.html do
        @event_date.destroy!
        redirect_to event_dates_path, status: :see_other, notice: 'Event date was successfully destroyed.'
      end

      format.json do
        @event_date.destroy!
        head :no_content
      end

      format.turbo_stream do
        @kwargs[:volunteer_name] = @event_date.volunteer.name
        @kwargs[:bringing] = @event_date.bringing
        @kwargs[:date] = @event_date.full_date

        OwnerMailer.with(event: @event_date.chesed_train, task: @event_date,
                         volunteer: current_user).volunteer_removed.deliver_now

        TwilioService.call(@event_date.chesed_train.owner, 'chesed_train_removed', **@kwargs)

        @event_date.update(volunteer_id: nil, bringing: nil, special_note: nil)
        render turbo_stream: [
          turbo_stream.remove(@event_date),
          turbo_stream.prepend('flash', partial: 'shared/alert')
        ]
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event_date
    @event_date = EventDate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_date_params
    params.require(:event_date).permit(:id, :bringing, :volunteer_id)
  end

  def set_kwargs
    @kwargs = {}
  end
end
