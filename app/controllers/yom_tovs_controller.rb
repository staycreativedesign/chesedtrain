class YomTovsController < ApplicationController
  before_action :find_event, only: [:index]
  before_action :set_kwargs, only: %i[destroy update]

  def index
    @event_dates = @event.event_dates.select { |ed| %w[Friday Saturday].include?(ed.date_weekday) }
  end

  def update
    binding.pry
    success = true

    if params[:event_date] && params[:event_date][:selections_attributes]
      params[:event_date][:selections_attributes].each do |_, selection_params|
        selection = Selection.find(selection_params[:id])
        success = false unless selection.update(selection_params.permit(:id, :name, :quantity, :special_note))
      end

      flash.now[:notice] = 'Updated Shabbat'
      @event = Event.find(params[:id])
      @event_dates = @event.event_dates.select { |ed| %w[Friday Saturday].include?(ed.date_weekday) }
      render :index, status: :ok
      respond_to do |format|
        format.turbo_stream do
        end
      end
    elsif params[:selection][:bringing]

      @selection = Selection.find(params[:id])
      @selection.update(bringing: params[:selection][:bringing])

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = 'Updated Successfully'

          render turbo_stream: turbo_stream.update(
            'flash',
            partial: 'shared/alert'
          )
        end
      end

      @kwargs[:volunteer_name] = @selection.volunteer.name
      @kwargs[:bringing] = params[:selection][:bringing]
      @kwargs[:date] = @selection.potluck_date.strftime('%A %b %d')

      OwnerMailer.with(event: @selection.event_date.chesed_train, task: @selection,
                       volunteer: current_user).volunteer_update.deliver_now

      TwilioService.call(@selection.event_date.chesed_train.owner, 'potluck_updated', **@kwargs)
    else

    end
  end

  def destroy
    @selection = Selection.find(params[:id])
    flash.now[:notice] = 'Stopped Volunteering'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@selection),
          turbo_stream.prepend('flash', partial: 'shared/alert')
        ]
      end
    end

    @kwargs[:volunteer_name] = @selection.volunteer.name
    @kwargs[:bringing] = @selection.bringing
    @kwargs[:date] = @selection.potluck_date.strftime('%A %b %d')

    OwnerMailer.with(event: @selection.event_date.chesed_train, task: @selection,
                     volunteer: current_user).volunteer_removed.deliver_now

    TwilioService.call(@selection.event_date.chesed_train.owner, 'chesed_train_removed', **@kwargs)

    @selection.update(volunteer_id: nil, bringing: nil, special_note: nil)
  end

  private

  def find_event
    @event = Event.friendly.find(params[:id])
  end

  def set_kwargs
    @kwargs = {}
  end
end
