class RemoveBotsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    users = User.where('LENGTH(first_name) >= 8')

    users.find_each do |user|
      user.destroy
    rescue StandardError => e
      Rails.logger.error("Failed to destroy user #{user.id}: #{e.message}")
    end

    # Remove remaining guests that match the condition
    User.where('LENGTH(first_name) >= 8', guest: true).destroy_all
  end
end
