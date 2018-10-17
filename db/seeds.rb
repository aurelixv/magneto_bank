# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'parallel'

TOTAL_CLIENTS = 10000
TOTAL_CARDS = 3..5
MONTHLY_TRANSACTIONS = 1200
TOTAL_TRANSACTIONS = 5 * 12 * MONTHLY_TRANSACTIONS
=begin
Client.delete_all
Card.delete_all
Transaction.delete_all

semaphore = Mutex.new

Parallel.map(1..TOTAL_CLIENTS, progress: "Criando #{TOTAL_CLIENTS} clientes...", in_threads: 3) do
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

Parallel.map(Client.first.id..Client.last.id, progress: "Criando #{TOTAL_CARDS} cartões...", in_threads: 3) do |client|
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
=end
pool = []
clients = Client.last.id.to_i - Client.first.id.to_i + 1
increase = clients/5
firstClient = Client.first.id.to_i
lastClient = firstClient + increase
pg_semaphore = Mutex.new
for fileNum in 1..5
    pool << Thread.new(fileNum, firstClient, lastClient) {
        File.open("transactions#{fileNum}.sql", 'w') {|f| f.puts 'COPY public.transactions (transaction_type, value, transaction_date, created_at, updated_at, card_id) FROM stdin;' + "\n"}
        file = File.open("transactions#{fileNum}.sql", 'a')
        thread_semaphore = Mutex.new
        for client in firstClient..lastClient
            p 'Client: ' + client.to_s
            current_client = 0
            client_cards = 0
            first_card = 0
            last_card = 0
            begin
                pg_semaphore.synchronize {
                    current_client = Client.where(id: client)[0]
                    client_cards = Client.where(id: client)[0].cards.length
                    first_card = Client.where(id: client)[0].cards.first.id
                    last_card = Client.where(id: client)[0].cards.last.id
                }
                transactions_per_card = MONTHLY_TRANSACTIONS / client_cards
                Parallel.each(first_card..last_card) do |card|
                    5.times do
                        12.times do
                            transactions_per_card.times do
                                month = rand(1..12)
                                month == 2 ? days = 28 : days = 30
                                transaction_type = Faker::Commerce.department
                                value = Faker::Number.decimal(rand(2..3), 2)
                                transaction_date = Date.new(rand(2013..2017), month, rand(1..days))
                                created_at = DateTime.now
                                updated_at = DateTime.now
                                card_id = card
                                string = transaction_type.to_s + "\t" + value.to_s + "\t" + transaction_date.to_s + "\t" + created_at.to_s + "\t" + updated_at.to_s + "\t" + card_id.to_s + "\n" 
                                thread_semaphore.synchronize {
                                    file.write(string)
                                }
                            end
                        end
                    end
                end
            rescue Exception => e
                p 'Erro no postgresql'
            end
        end
        file.close
    }.run
    sleep(1)
    firstClient += increase
    lastClient += increase
end
pool.each(&:join) 
