module EventsHelper
  def type_of_event(event)
    if event.try(:potluck_id).blank? && event.try(:event_date_id)&.present?
      chesed_train_yom_tov_path(event.event_date.chesed_train.id, event)
    elsif event.try(:potluck_id).present?
      potluck_selection_path(event.potluck, event)
    else
      chesed_train_event_date_path(event.chesed_train, event)
    end
  end
end
