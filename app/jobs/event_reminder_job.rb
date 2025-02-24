class EventReminderJob < ApplicationJob
  queue_as :default

  def perform
    chesed_trains = EventDate.where(
      full_date: 1.days.from_now.beginning_of_day..1.days.from_now.end_of_day
    ).where.not(volunteer_id: nil).map { |e| [e.volunteer, e] }

    chesed_trains_two_day = EventDate.where(
      full_date: 2.days.from_now.beginning_of_day..2.days.from_now.end_of_day
    ).where.not(volunteer_id: nil).map { |e| [e.volunteer, e] }

    potlucks_two_day = Selection.where(
      potluck_date: 2.days.from_now.beginning_of_day..2.days.from_now.end_of_day
    ).where.not(volunteer_id: nil).map { |e| [e.volunteer, e] }

    potlucks = Selection.where(
      potluck_date: 1.days.from_now.beginning_of_day..1.days.from_now.end_of_day
    ).where.not(volunteer_id: nil).map { |e| [e.volunteer, e] }

    run_potlucks(potlucks)
    run_potlucks(potlucks_two_day)
    run_chesed_trains(chesed_trains)
    run_chesed_trains(chesed_trains_two_day)
  end

  def run_potlucks(potlucks)
    return if potlucks.blank?

    potlucks.each do |ct|
      VolunteerMailer.reminder(ct,
                               ct[1]&.potluck&.preferred_time? ? ct[1].potluck.preferred_time : 'no time specified.', 'potluck').deliver_now
      TwilioReminderService.call(ct,
                                 (ct[1]&.potluck&.preferred_time? ? ct[1].potluck.preferred_time : 'no time specified.'),
                                 'potluck')
    end
  end

  def run_chesed_trains(chesed_trains)
    return if chesed_trains.blank?

    chesed_trains.each do |ct|
      VolunteerMailer.reminder(ct,
                               ct[1]&.chesed_train&.preferred_time? ? ct[1].chesed_train.preferred_time : 'no time specified.', 'chesed_train').deliver_now
      TwilioReminderService.call(ct,
                                 (ct[1]&.chesed_train&.preferred_time? ? ct[1].chesed_train.preferred_time : 'no time specified.'),
                                 'chesed_train')
    end
  end
end
