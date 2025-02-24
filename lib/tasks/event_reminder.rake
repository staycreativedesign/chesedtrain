namespace :event_reminder do
  desc "Send text and emails for events happening two days from now"
  task send: :environment do
    puts "Running EventReminderJob for events happening in 2 days..."
    EventReminderJob.perform_now
    puts "EventReminderJob execution completed."
  end
end
