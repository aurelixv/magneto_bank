require 'faker'
require 'parallel'
require 'ruby-progressbar'

TOTAL_CLIENTS = 10_000
TOTAL_CARDS = 3..5
MONTHLY_TRANSACTIONS = 1200
TOTAL_TRANSACTIONS = 5 * 12 * MONTHLY_TRANSACTIONS
DATABASE = 'magneto'.freeze

Client.delete_all
Card.delete_all
Transaction.delete_all

db_semaphore = Mutex.new

Parallel.map(1..TOTAL_CLIENTS, progress: "Criando #{TOTAL_CLIENTS} clientes", in_threads: 3) do
  name = Faker::Name.name_with_middle
  email = Faker::Internet.unique.free_email
  address = Faker::Address.street_address
  zip_code = Faker::Address.zip_code
  password = Faker::Crypto.md5
  ssid = Faker::Number.number(11)
  birth_date = Faker::Date.birthday(20, 70)

  db_semaphore.synchronize do
    Client.create!(
      name: name,
      email: email,
      address: address,
      zip_code: zip_code,
      password: password,
      ssid: ssid,
      birth_date: birth_date
    )
  end
end

Parallel.map(Client.first.id..Client.last.id, progress: "Criando #{TOTAL_CARDS} cartões", in_threads: 3) do |client|
  rand(TOTAL_CARDS).times do
    card_type = Faker::Boolean.boolean,
    card_number = Faker::Finance.unique.credit_card(:mastercard)
    verification_number = Faker::Number.number(3)
    aquisition_date = Faker::Date.birthday(5, 10)
    # due_date = Faker::Date.birthday(5, 10)
    client_id = client
    db_semaphore.synchronize do
      Card.create!(
        card_type: card_type,
        card_number: card_number,
        verification_number: verification_number,
        aquisition_date: aquisition_date,
        # due_date: due_date,
        client_id: client_id
      )
    end
  end
end

FAKE_VALUES = 10_000
faker = {
  transaction_type: [],
  value: []
}

print 'Gerando dicionário de dados aleatórios... '
(FAKE_VALUES + 1).times do
  faker[:transaction_type] << Faker::Commerce.department.to_s
  faker[:value] << Faker::Number.decimal(rand(2..3), 2).to_s
end
puts 'OK'

pool = []
clients = Client.last.id.to_i - Client.first.id.to_i + 1
increase = clients / 5
firstClient = Client.first.id.to_i
lastClient = firstClient + increase - 1
today = DateTime.now.to_s

progress_bar = ProgressBar.create(
  format: '%t | %a %e %P% Cliente: %c de %C',
  title: "Criando #{TOTAL_TRANSACTIONS * TOTAL_CLIENTS} transações",
  total: TOTAL_CLIENTS
)

# TODO: One pg connection per thread
(1..5).each do |fileNum|
  pool << Thread.new(fileNum, firstClient, lastClient) do
    File.open("results/transactions#{fileNum}.sql", 'w') { |f| f.puts 'COPY public.transactions (transaction_type, value, transaction_date, created_at, updated_at, card_id, is_debt) FROM stdin;' + "\n" }
    file = File.open("results/transactions#{fileNum}.sql", 'a')
    thread_semaphore = Mutex.new
    (firstClient..lastClient).each do |client|
      client_balance = 0
      current_client = 0
      client_cards = 0
      cards = 0
      begin
        db_semaphore.synchronize do
          current_client = Client.where(id: client)[0]
          client_cards = current_client.cards.length.to_i
          cards = current_client.cards.each
        end
        transactions_per_card = MONTHLY_TRANSACTIONS / client_cards
        # Parallel.each(cards) do |card|
        cards.each do |card|
          card_balance = 0
          (2013..2017).each do |year|
            (1..12).each do |month|
              transactions_per_card.times do
                days = month == 2 ? 28 : 30
                transaction_type = faker[:transaction_type][rand(0..FAKE_VALUES)]
                value = faker[:value][rand(0..FAKE_VALUES)]
                transaction_date = Date.new(year, month, rand(1..days)).to_s
                card_id = card.id.to_s
                is_debt = false.to_s
                if rand(0..100) > 50
                  is_debt = true.to_s
                  card_balance -= value.to_f
                else
                  card_balance += value.to_f
                end
                string = transaction_type + "\t" + value + "\t" + transaction_date + "\t" + today + "\t" + today + "\t" + card_id + "\t" + is_debt + "\n"
                thread_semaphore.synchronize do
                  file.write(string)
                end
              end
            end
          end
          card.balance = card_balance
          card.save
          client_balance += card_balance
        end

      rescue Exception => e
        puts 'ERRO'
        puts e
        sleep(5)
      end
      current_client.balance = client_balance
      current_client.save
      progress_bar.increment
    end
    file.close
  end.run
  sleep(1)
  firstClient += increase
  lastClient += increase
end
pool.each(&:join)

puts 'Inserindo no banco de dados...'
(1..5).each do |i|
  puts "Arquivo #{i}..."
  system("psql -d #{DATABASE} -c \"\\i 'results/transactions#{i}.sql'\"")
  puts 'OK'
end

puts 'Script finalizado com sucesso!'
