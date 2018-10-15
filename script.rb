gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'

require 'faker'

TOTAL_CLIENTS = 10000

p Card.first.id

file = File.open('teste', 'w')

=begin 
    TOTAL_CLIENTS.times do
    file.write(Faker::Name.name_with_middle + "\t")
    file.write(Faker::Internet.unique.free_email + ' ')
    file.write(Faker::Address.street_address + ' ')
    file.write(Faker::Address.zip_code + ' ')
    file.write(Faker::Crypto.md5 + ' ')
    file.write(Faker::Number.number(11) + ' ')
    file.write(Faker::Date.birthday(20, 70))
    file.write("\n")
end
=end

file.close

