users = User.where('LENGTH(first_name) >= 8')
users.each do |user|
  user.destroy
rescue StandardError
  next
end

users.where(guest: true).destroy_all
