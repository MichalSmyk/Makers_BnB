require 'faker'
require 'database_cleaner'

puts "🌱 Seeding spices..."

DatabaseCleaner.clean_with(:truncation)

User.create(
  username: "abodian",
  password: "test",
  first_name: "Alex",
  last_name: "Bodian",
  email: "abodian@email.com",
  mobile_number: "+44714241945",
)
User.create(
  username: "jburgess",
  password: "test",
  first_name: "Joe",
  last_name: "Burgess",
  email: "jburgess@email.com",
  mobile_number: "+44712345678",
)
User.create(
  username: "dscott",
  password: "test",
  first_name: "David",
  last_name: "Scott",
  email: "dscott@email.com",
  mobile_number: "+4471234738",
)
Space.create(
  name: "Lovely Cottage",
  description: "A lovely cottage located in rural Hertfordshire",
  price: "120",
  address: "This is a fake address, at fake adddress street, fake county, FK01 CNT",
  user_id: "1"
)
Space.create(
  name: "Seaside Cottage",
  description: "A lovely seaside cottage located by the sea!",
  price: "90",
  address: "This is a fake address at the seaside, at fake adddress street, fake county, FK01 CNT",
  user_id: "3"
)
Space.create(
  name: "Little Bungalow",
  description: "A tiny bungalow in the middle of nowhere with very little space and it is 100% haunted!",
  price: "165",
  address: "This is a haunted address, at fake adddress street, fake county, FK01 CNT",
  user_id: "2"
)
# Request approval types: 1 = Pending, 2 = Approved, 3 = Declined
Booking.create(
  stay_date: "20/01/2023",
  request_time: "19/01/2023 16:44:23",
  request_approval: "1",
  space_id: "1",
  user_id: "1"
)
Booking.create(
  stay_date: "21/01/2023",
  request_time: "19/01/2023 16:44:23",
  request_approval: "2",
  space_id: "1",
  user_id: "1"
)
Booking.create(
  stay_date: "22/01/2023",
  request_time: "19/01/2023 16:44:23",
  request_approval: "3",
  space_id: "1",
  user_id: "1"
)
Booking.create(
  stay_date: "23/01/2023",
  request_time: "20/01/2023 14:40:19",
  request_approval: "2",
  space_id: "2",
  user_id: "2"
)
Booking.create(
  stay_date: "28/03/2023",
  request_time: "28/01/2023 13:25:35",
  request_approval: "3",
  space_id: "3",
  user_id: "3"
)
SpaceDate.create(
  date_available: "20/01/23",
  space_id: "1"
)
SpaceDate.create(
  date_available: "21/01/23",
  space_id: "1"
)
SpaceDate.create(
  date_available: "22/01/23",
  space_id: "1"
)
SpaceDate.create(
  date_available: "30/01/23",
  space_id: "2"
)
SpaceDate.create(
  date_available: "03/02/23",
  space_id: "3"
)

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
