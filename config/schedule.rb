# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, './cron_log.log'
every 1.day, at: '8:00am' do
  rake 'event_reminder:send'
end

every 3.hours do
  rake 'bot_removal:send'
end
