require 'faker'
require 'database_cleaner'

puts "🌱 Seeding spices..."

DatabaseCleaner.clean_with(:truncation)

20.times do
  User.create(
    username: Faker::Internet.unique.username,
    password: Faker::Internet.password,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    mobile_number: Faker::PhoneNumber.cell_phone_with_country_code
  )
end

20.times do
  Space.create(
    name: Faker::Address.street_address,
    description: Faker::Lorem.sentence(word_count: rand(2..10)).chomp('.'),
    price: Faker::Number.between(from: 85, to: 185),
    address: Faker::Address.full_address,
    user_id: Faker::Number.between(from: 1, to: 20)
  )
end

20.times do
  Booking.create(
    stay_date: Faker::Date.forward(days: 100),
    request_time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default),
    request_approval: Faker::Number.between(from: 1, to: 3),
    space_id: Faker::Number.between(from: 1, to: 20),
    user_id: Faker::Number.between(from: 1, to: 20)
  )
end

20.times do
  SpaceDate.create(
    date_available: Faker::Date.forward(days: 100),
    space_id: Faker::Number.between(from: 1, to: 5)
  )
end

puts "✅ Done seeding!"
