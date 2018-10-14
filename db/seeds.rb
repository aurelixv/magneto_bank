# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

Client.delete_all
Card.delete_all
Transaction.delete_all

10000.times do
    Client.create(
        name: Faker::Name.name_with_middle,
        email: Faker::Internet.unique.free_email,
        address: Faker::Address.street_address,
        zip_code: Faker::Address.zip_code,
        password: Faker::Crypto.md5,
        ssid: Faker::IDNumber.brazilian_citizen_number,
        birth_date: Faker::Date.birthday(20, 70)
    )
end