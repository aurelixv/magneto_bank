require 'faker'
require 'parallel'

TOTAL_CLIENTS = 1000
TOTAL_CARDS = 1..2
MONTHLY_TRANSACTIONS = 200
TOTAL_TRANSACTIONS = 5 * 12 * MONTHLY_TRANSACTIONS

Client.delete_all
Card.delete_all
Transaction.delete_all

db_semaphore = Mutex.new

Parallel.map(1..TOTAL_CLIENTS, progress: "Criando #{TOTAL_CLIENTS} clientes\t", in_threads: 3) do
    name = Faker::Name.name_with_middle
    email = Faker::Internet.unique.free_email
    address = Faker::Address.street_address
    zip_code = Faker::Address.zip_code
    password = Faker::Crypto.md5
    ssid = Faker::Number.number(11)
    birth_date = Faker::Date.birthday(20, 70)

    db_semaphore.synchronize {
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

Parallel.map(Client.first.id..Client.last.id, progress: "Criando #{TOTAL_CARDS} cartões\t", in_threads: 3) do |client|
    rand(TOTAL_CARDS).times do
        card_type = Faker::Boolean.boolean,
        card_number = Faker::Finance.unique.credit_card(:mastercard)
        verification_number = Faker::Number.number(3)
        aquisition_date = Faker::Date.birthday(5, 10)
        due_date = Faker::Date.birthday(5, 10)
        client_id = client
        db_semaphore.synchronize {
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

FAKE_VALUES = 10_000
faker = {
    transaction_type: [],
    value: []
}

print "Gerando dicionário de dados aleatórios... "
(FAKE_VALUES + 1).times do
    faker[:transaction_type] << Faker::Commerce.department
    faker[:value] << Faker::Number.decimal(rand(2..3), 2)
end
puts "OK"

pool = []
clients = Client.last.id.to_i - Client.first.id.to_i + 1
increase = clients/5
firstClient = Client.first.id.to_i
lastClient = firstClient + increase - 1
today = DateTime.now

progress_bar = ProgressBar.create(
    format: "%t | %a %e %P% Cliente: %c de %C",
    title: "Criando transações\t",
    total: TOTAL_CLIENTS
)

#TODO One pg connection per thread
for fileNum in 1..5
    pool << Thread.new(fileNum, firstClient, lastClient) {
        File.open("results/transactions#{fileNum}.sql", 'w') {|f| f.puts 'COPY public.transactions (transaction_type, value, transaction_date, created_at, updated_at, card_id) FROM stdin;' + "\n"}
        file = File.open("results/transactions#{fileNum}.sql", 'a')
        thread_semaphore = Mutex.new
        for client in firstClient..lastClient
            current_client = 0
            client_cards = 0
            first_card = 0
            last_card = 0
            begin
                db_semaphore.synchronize {
                    current_client = Client.where(id: client)[0]
                    client_cards = Client.where(id: client)[0].cards.length
                    first_card = Client.where(id: client)[0].cards.first.id
                    last_card = Client.where(id: client)[0].cards.last.id
                }
                transactions_per_card = MONTHLY_TRANSACTIONS / client_cards
                Parallel.each(first_card..last_card) do |card|
                    for year in 1..5 do
                        for month in 1..12 do
                            transactions_per_card.times do
                                month == 2 ? days = 28 : days = 30
                                transaction_type = faker[:transaction_type][rand(0..FAKE_VALUES)]
                                value = faker[:value][rand(0..FAKE_VALUES)]
                                transaction_date = Date.new(year, month, rand(1..days))
                                created_at = today
                                updated_at = today
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
                puts "Erro no postgresql"
                sleep(5)
            end
            progress_bar.increment
        end
        file.close
    }.run
    sleep(1)
    firstClient += increase
    lastClient += increase
end
pool.each(&:join)

puts "Inserindo no banco de dados..."
for i in 1..5
    puts "Arquivo #{i}..."
    system("psql -d minha -c \"\\i 'results/transactions#{i}.sql'\"")
    puts "OK"
end

puts "Script finalizado com sucesso!"
