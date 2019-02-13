user_list = []

12.times do
  username = Faker::Name.first_name
  email = Faker::Internet.email(username)
  password = Faker::Internet.password(10)

  # Add user to user_list
  user_list << [username, email, password]
end

user_list.each do |username, email, password|
  User.create(username: username, email: email, password: password)
end
