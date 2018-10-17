require 'faker'

faker = {
    transaction_type: [],
    value: [],
    card_id: []
}

1000.times do
    faker[:transaction_type] << Faker::Commerce.unique.department
    faker[:value] << Faker::Number.unique.decimal(rand(2..3), 2)
end

p faker[:transaction_type]

File.open("teste.sql", 'w') {|f| f.puts 'COPY public.transactions (transaction_type, value, transaction_date, created_at, updated_at, card_id) FROM stdin;' + "\n"}
file = File.open("teste.sql", 'a')
p today = DateTime.now
for time in 1..12000000
    p DateTime.now if time % 1000000 == 0
    month = rand(1..12)
    month == 2 ? days = 28 : days = 30
    transaction_type = faker[:transaction_type][rand(0..999)]
    value = faker[:value][rand(0..999)]
    transaction_date = Date.new(rand(2013..2017), month, rand(1..days))
    created_at = today
    updated_at = today
    card_id = rand(1..1000)
    string = transaction_type.to_s + "\t" + value.to_s + "\t" + transaction_date.to_s + "\t" + created_at.to_s + "\t" + updated_at.to_s + "\t" + card_id.to_s + "\n" 
    file.write(string)
end
#month == 2 ? days = 28 : days = 30
#month = rand(1..12)
