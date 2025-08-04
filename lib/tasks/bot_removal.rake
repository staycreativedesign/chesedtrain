namespace :bot_removal do
  desc "Remove bots"
  task send: :environment do
    puts "[#{Time.current}] Running RemoveBotsJob for bot cleanup..."
    RemoveBotsJob.perform_now
    puts "[#{Time.current}] RemoveBotsJob execution completed."
  end
end
