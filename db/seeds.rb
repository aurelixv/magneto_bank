# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'parallel'

Client.delete_all
Card.delete_all
Transaction.delete_all

TOTAL_CLIENTS = 1000
TOTAL_CARDS = 1..2
MONTHLY_TRANSACTIONS = 200
TOTAL_TRANSACTIONS = 5 * 12 * MONTHLY_TRANSACTIONS

semaphore = Mutex.new

Parallel.map(1..TOTAL_CLIENTS, progress: "Criando clientes...", in_threads: 3) do
    name = Faker::Name.name_with_middle
    email = Faker::Internet.unique.free_email
    address = Faker::Address.street_address
    zip_code = Faker::Address.zip_code
    password = Faker::Crypto.md5
    ssid = Faker::Number.number(11)
    birth_date = Faker::Date.birthday(20, 70)

    semaphore.synchronize {
        Client.create!(
            name: name,
            email: email,
            address: address,
            zip_code: zip_code,
            password: password,
            ssid: ssid,
            birth_date: birth_date
        )
    }
end

Parallel.map(Client.first.id..Client.last.id, progress: "Criando cartões...", in_threads: 3) do |client|
    rand(TOTAL_CARDS).times do
        card_type = Faker::Boolean.boolean,
        card_number = Faker::Finance.unique.credit_card(:mastercard)
        verification_number = Faker::Number.number(3)
        aquisition_date = Faker::Date.birthday(5, 10)
        due_date = Faker::Date.birthday(5, 10)
        client_id = client
        semaphore.synchronize {
            Card.create!(
                card_type: card_type,
                card_number: card_number,
                verification_number: verification_number,
                aquisition_date: aquisition_date,
                due_date: due_date,
                client_id: client_id
            )
        }
    end
end 

=begin 
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
File.open('transactions.sql', 'w') {|f| f.puts 'COPY public.transactions (transaction_type, value, transaction_date, created_at, updated_at, card_id) FROM stdin;' + "\n"}
file = File.open('transactions.sql', 'a')
#file.write('COPY public.transactions (transaction_type, value, transaction_date, created_at, updated_at, card_id) FROM stdin;' + "\n")
Parallel.map(Client.first.id..Client.last.id, progress: "Criando transacoes...", in_threads: 3) do |client|
    client_cards = Client.where(id: client)[0].cards.length
    transactions_per_card = MONTHLY_TRANSACTIONS / client_cards
    current_client = Client.where(id: client)[0]
    'Client: ' + current_client.id.to_s

    Parallel.each(current_client.cards) do |card|
        '     Card: ' + card.id.to_s

        5.times do
            12.times do
                transactions_per_card.times do
                    month = rand(1..12)
                    month == 2 ? days = 28 : days = 30
                    #string = Faker::Commerce.department + "\t" + Faker::Number.decimal(rand(2..3), 2).to_s + "\t" + Date.new(rand(2013..2017), month, rand(1..days)).to_s + "\t" + DateTime.now.to_s + "\t" + DateTime.now.to_s + "\t" + card.id.to_s + "\n"
                    transaction_type = Faker::Commerce.department
                    value = Faker::Number.decimal(rand(2..3), 2)
                    transaction_date = Date.new(rand(2013..2017), month, rand(1..days))
                    created_at = DateTime.now
                    updated_at = DateTime.now
                    card_id = card.id
                    string = transaction_type.to_s + "\t" + value.to_s + "\t" + transaction_date.to_s + "\t" + created_at.to_s + "\t" + updated_at.to_s + "\t" + card_id.to_s + "\n" 
                    semaphore.synchronize {
                        file.write(string)
=begin 
                        Transaction.create!(
                            transaction_type: transaction_type,
                            value: value,
                            transaction_date: transaction_date,
                            card_id: card_id,
                            created_at: created_at,
                            updated_at: updated_at
                        ) 
=end
                    }
                end
            end
        end
    end
end

#file.close
