# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

=begin 
Client.delete_all
Card.delete_all
Transaction.delete_all

TOTAL_CLIENTS = 10000
TOTAL_CARDS = 3..5
MONTHLY_TRANSACTIONS = 1200
TOTAL_TRANSACTIONS = 5 * 12 * MONTHLY_TRANSACTIONS 

TOTAL_CLIENTS.times do
    Client.create!(
        name: Faker::Name.name_with_middle,
        email: Faker::Internet.unique.free_email,
        address: Faker::Address.street_address,
        zip_code: Faker::Address.zip_code,
        password: Faker::Crypto.md5,
        ssid: Faker::IDNumber.brazilian_citizen_number,
        birth_date: Faker::Date.birthday(20, 70)
    )
end

count = Client.first.id
TOTAL_CLIENTS.times do
    rand(3..5).times do
        Card.create!(
            card_type: Faker::Boolean.boolean,
            card_number: Faker::Finance.unique.credit_card(:mastercard),
            verification_number: Faker::Number.number(3),
            aquisition_date: Faker::Date.birthday(5, 10),
            due_date: Faker::Date.birthday(5, 10),
            client_id: count
        )
    end
    count += 1
end 

first_card = Card.first.id
last_card = Card.last.id

year = 2013
5.times do
    month = 1
    12.times do
        1200.times do
            month == 2 ? days = 28 : days = 30
            Transaction.create!(
                transaction_type: Faker::Commerce.department,
                value: Faker::Commerce.price,
                transaction_date: Date.new(year, month, rand(1..days)),
                card_id: rand(first_card..last_card)
            )
        end
        month += 1
    end
    year += 1
end
=end

file = File.open('teste', 'w')

first_card = Card.first.id
last_card = Card.last.id

client = 1
10000.times do
    client_cards = Client.where(id: client)[0].cards

    year = 2013
    5.times do
        month = 1
        12.times do
            1200.times do
                month == 2 ? days = 28 : days = 30
                file.write(Faker::Commerce.department + "\t")
                file.write(Faker::Commerce.price.to_s + "\t")
                file.write(Date.new(year, month, rand(1..days)).to_s + "\t")
                file.write(rand(first_card..last_card ).to_s + "\t\n")
            end
            month += 1
        end
        year += 1
    end
    client += 1
end

file.close
