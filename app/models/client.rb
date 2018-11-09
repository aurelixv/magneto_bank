# == Schema Information
#
# Table name: clients
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  email      :string
#  address    :string
#  zip_code   :integer
#  password   :string
#  ssid       :bigint(8)
#  birth_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Client < ApplicationRecord
  has_many :cards
  has_many :transactions, through: :cards
end
